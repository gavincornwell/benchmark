package com.alfresco.mobile.benchmark.model;

/**
 * Created by gcornwell on 19/06/2014.
 */
public class BenchmarkObject
{
    private String name;
    private String description;

    public BenchmarkObject(String name, String description)
    {
        this.name = name;
        this.description = description;
    }

    public String getName()
    {
        return this.name;
    }

    public String getDescription()
    {
        return this.description;
    }

    @Override
    public String toString()
    {
        return this.name + " " + this.description;
    }
}
