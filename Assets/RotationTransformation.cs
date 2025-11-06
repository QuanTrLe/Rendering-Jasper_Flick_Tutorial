using UnityEngine;

public class RotationTransformation : Transformation {

	public Vector3 rotation;

	// built by matrix multiplication hell yeah
	// using around sin and cos of the axis we're rotating, compare the position of the other two axis (1, 0, or -1) when spinning
	// total rotation matrix is all three matrixes of the axises combined / multiplied together
	// then multiply by the current position so that we get proper rotation outside of the unit circle
	public override Vector3 Apply(Vector3 point)
	{
		// the radians we need to find angle of rotation
		float radX = rotation.x * Mathf.Deg2Rad;
		float radY = rotation.y * Mathf.Deg2Rad;
		float radZ = rotation.z * Mathf.Deg2Rad;

		// the sin and cos to base all the other rotation on
		float sinX = Mathf.Sin(radX);
		float cosX = Mathf.Cos(radX);
		float sinY = Mathf.Sin(radY);
		float cosY = Mathf.Cos(radY);
		float sinZ = Mathf.Sin(radZ);
		float cosZ = Mathf.Cos(radZ);

		// the rotation based on each axis, to be combined
		Vector3 xAxis = new Vector3(
			cosY * cosZ,
			cosX * sinZ + sinX * sinY * cosZ,
			sinX * sinZ - cosX * sinY * cosZ
		);
		Vector3 yAxis = new Vector3(
			-cosY * sinZ,
			cosX * cosZ - sinX * sinY * sinZ,
			sinX * cosZ + cosX * sinY * sinZ
		);
		Vector3 zAxis = new Vector3(
			sinY,
			-sinX * cosY,
			cosX * cosY
		);

		// combine all the matrix of each each axis, and also the point position
		return xAxis * point.x + yAxis * point.y + zAxis * point.z;
	}
}