using UnityEngine;
using System.Collections.Generic;

public class TransformationGrid : MonoBehaviour {

    public Transform prefab; // the thing we're making our grid out of
	public int gridResolution = 10; // how big the grid
    Transform[] grid;

    // list bc we're getting this every update and avoid makign a new array each time
    List<Transformation> transformations;

    // matrix containing all the transformation operations weve been doing so far
    Matrix4x4 transformation;


    void Awake()
    {
        // making and populating the grid
        grid = new Transform[gridResolution * gridResolution * gridResolution];
        for (int i = 0, z = 0; z < gridResolution; z++)
        {
            for (int y = 0; y < gridResolution; y++)
            {
                for (int x = 0; x < gridResolution; x++, i++)
                {
                    grid[i] = CreateGridPoint(x, y, z);
                }
            }
        }

        // using a list bc we're getting components every update
        // avoid making a new array everytime and just put the elements inside the list we have
        transformations = new List<Transformation>();
    }


    void Update()
    {
        // getting component each update to be able to edit and test in play mode
        UpdateTransformation();

        for (int i = 0, z = 0; z < gridResolution; z++)
        {
            for (int y = 0; y < gridResolution; y++)
            {
                for (int x = 0; x < gridResolution; x++, i++)
                {
                    grid[i].localPosition = TransformPoint(x, y, z);
                }
            }
        }
    }


    // instantiate the prefab of the point and position them at each point
    // also color them for pretiness / debugging
    Transform CreateGridPoint(int x, int y, int z)
    {
        Transform point = Instantiate<Transform>(prefab);
        point.localPosition = GetCoordinates(x, y, z);
        point.GetComponent<MeshRenderer>().material.color = new Color(
            (float)x / gridResolution,
            (float)y / gridResolution,
            (float)z / gridResolution
        );
        return point;
    }


    // get coords of point based on x/y/z and the grid resolution
    Vector3 GetCoordinates(int x, int y, int z)
    {
        return new Vector3(
            x - (gridResolution - 1) * 0.5f,
            y - (gridResolution - 1) * 0.5f,
            z - (gridResolution - 1) * 0.5f
        );
    }


    // getting original coordinates and apply each transformation
    // dont rely on actual position of points to avoid accumulating transformations each frame
    Vector3 TransformPoint(int x, int y, int z)
    {
        Vector3 coordinates = GetCoordinates(x, y, z);
        return transformation.MultiplyPoint(coordinates);
    }
    
    // base it on the transform matrix we've defined in the other scripts so far 
    void UpdateTransformation () {
        GetComponents<Transformation>(transformations);
        
		if (transformations.Count > 0) { // go over and apply it to the points
			transformation = transformations[0].Matrix;
			for (int i = 1; i < transformations.Count; i++) {
                transformation = transformations[i].Matrix * transformation;
			}
		}
	}
}
