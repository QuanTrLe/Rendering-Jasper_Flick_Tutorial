using UnityEngine;

public class RotationTransformation : Transformation {

	public Vector3 rotation;

	public override Vector3 Apply (Vector3 point) {
        // since when we're rotating from the perspective of the z axis it all goes in a circle
        // if we chart the circle path out, it's in a graph of sin and cos
        float radZ = rotation.z * Mathf.Deg2Rad;
		float sinZ = Mathf.Sin(radZ);
        float cosZ = Mathf.Cos(radZ);

        // to make sure that when we rotate we also take care of position outside of the unit circle
        // looks weird but it's jsut the component of x and y combined though
        return new Vector3(
			point.x * cosZ - point.y * sinZ,
			point.x * sinZ + point.y * cosZ,
			point.z
		);
	}
}