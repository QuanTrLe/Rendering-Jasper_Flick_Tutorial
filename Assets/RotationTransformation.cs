using UnityEngine;

public class RotationTransformation : Transformation {

	public Vector3 rotation;

	// built by matrix multiplication hell yeah
	// using around sin and cos of the axis we're rotating, compare the position of the other two axis (1, 0, or -1) when spinning
	// total rotation matrix is all three matrixes of the axises combined / multiplied together
	// then multiply by the current position so that we get proper rotation outside of the unit circle
	public override Matrix4x4 Matrix
	{
		get {
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

			Matrix4x4 matrix = new Matrix4x4();

			// fill rotation matrix row by row
			matrix.SetColumn(0, new Vector4( // x axis
				cosY * cosZ,
				cosX * sinZ + sinX * sinY * cosZ,
				sinX * sinZ - cosX * sinY * cosZ,
				0f
			));
			matrix.SetColumn(1, new Vector4( // y axis
				-cosY * sinZ,
				cosX * cosZ - sinX * sinY * sinZ,
				sinX * cosZ + cosX * sinY * sinZ,
				0f
			));
			matrix.SetColumn(2, new Vector4( // z axis
				sinY,
				-sinX * cosY,
				cosX * cosY,
				0f
			));
			matrix.SetColumn(3, new Vector4(0f, 0f, 0f, 1f)); // last one is partly for position, just identity

			return matrix;
		}
	}
}