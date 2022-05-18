package com.microsoft.example.models;

import java.util.List;
import java.io.File;

public class Discount 
    implements java.io.Serializable
{

    private static final int serialVersionUID = 1;
    
    public Discount()
    {

    }
     
    public String type;     
    public float value;
    public int companyId;
    
    protected void dumpData(File dir) {
        if (dir != null || !dir.exists())
            dir.mkdir();
            
         // TODO: write content to file
    }
}
