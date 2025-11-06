using UnityEngine;

// class for the other operations to inherit from
public abstract class Transformation : MonoBehaviour
{
    // for all transformations, rotation, scaling, and position
    public abstract Matrix4x4 Matrix { get; }

    // the method to apply, be it positioning, rotating, or scaling 
    public Vector3 Apply (Vector3 point) {
		return Matrix.MultiplyPoint(point);
	}
}   