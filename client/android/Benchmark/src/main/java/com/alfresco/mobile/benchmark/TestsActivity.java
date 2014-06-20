package com.alfresco.mobile.benchmark;

import android.app.ListActivity;
import android.os.AsyncTask;
import android.os.Bundle;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.util.Log;
import android.widget.ListView;
import android.widget.Toast;

import com.alfresco.mobile.benchmark.model.BenchmarkObject;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.util.ArrayList;
import java.util.List;

// ***************************************************************************
// TODO: Refactor this to use AsyncTaskLoader rather than the older AsyncTask
//       Also use a better layout for the list view i.e. something like
//       http://www.vogella.com/tutorials/AndroidListView/article.html
// ***************************************************************************

public class TestsActivity extends ListActivity
{
    private static final String TAG = "TestsActivity";
    private ArrayAdapter<BenchmarkObject> mAdapter = null;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        BenchmarkObject test1 = new BenchmarkObject("Loading...", "");
        ArrayList<BenchmarkObject> tests = new ArrayList<BenchmarkObject>();
        tests.add(test1);

        mAdapter = new ArrayAdapter<BenchmarkObject>(
                this,
                R.layout.tests_row,
                tests);

        setListAdapter(mAdapter);

        // call the async task to retrieve the tests
        new RetrieveTestsTask().execute("");
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.tests, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings)
        {
            Toast.makeText(this, "Selected settings menu", Toast.LENGTH_SHORT).show();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id)
    {
        Toast.makeText(this, "Selected row with id " + id, Toast.LENGTH_SHORT).show();
    }

    class RetrieveTestsTask extends AsyncTask<String, Integer, List<BenchmarkObject>>
    {
        @Override
        protected List<BenchmarkObject> doInBackground(String... strings)
        {
            Log.i(TAG, "Loading tests in background...");

            HttpClient httpClient = null;
            try
            {
                HttpGet getRequest = new HttpGet("http://10.0.1.5:9080/alfresco-benchmark-server/api/v1/tests");
                ResponseHandler<String> handler = new BasicResponseHandler();
                httpClient = new DefaultHttpClient();
                String response = httpClient.execute(getRequest, handler);

                return parseResponse(response);
            }
            catch (Exception e)
            {
                throw new RuntimeException("Failed to retrieve tests", e);
            }
            finally
            {
                if (httpClient != null)
                {
                    httpClient.getConnectionManager().shutdown();
                }
            }
        }

        @Override
        protected void onPostExecute(List<BenchmarkObject> list)
        {
            Log.i(TAG, "Finished loading tests, updating UI...");

            // update the UI with the list, notify the list adapter the data has changed
            mAdapter.clear();
            mAdapter.addAll(list);
            mAdapter.notifyDataSetChanged();
        }

        @Override
        protected void onProgressUpdate(Integer... values)
        {
            super.onProgressUpdate(values);
        }

        private List<BenchmarkObject> parseResponse(String jsonResponse) throws JSONException
        {
            ArrayList<BenchmarkObject> tests = new ArrayList<BenchmarkObject>();

            JSONTokener tokenizer = new JSONTokener(jsonResponse);
            JSONArray array = (JSONArray)tokenizer.nextValue();
            for (int i = 0; i < array.length(); i++)
            {
                JSONObject jsonObject = (JSONObject)array.get(i);
                String name = jsonObject.getString("name");
                String description = jsonObject.getString("description");
                BenchmarkObject test = new BenchmarkObject(name, description);
                tests.add(test);
            }

            return tests;
        }
    }
}
