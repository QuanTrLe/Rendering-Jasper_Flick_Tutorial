using UnityEngine;

// class for the other operations to inherit from
public abstract class Transformation : MonoBehaviour
{

    // the method to apply, be it positioning, rotating, or scaling 
    public abstract Vector3 Apply(Vector3 point);
}   