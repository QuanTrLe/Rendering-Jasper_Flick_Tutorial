using UnityEngine;

public class CameraTransformation : Transformation {
	// focal length / dist between the origin and the projection plane
	// larger means smaller fov, focal length 1 is 90deg view
	// basically larger focal length is zooming in?
	public float focalLength = 1f;

	public override Matrix4x4 Matrix {
		get {
			Matrix4x4 matrix = new Matrix4x4();
			matrix.SetRow(0, new Vector4(focalLength, 0f, 0f, 0f));
			matrix.SetRow(1, new Vector4(0f, focalLength, 0f, 0f));
			matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
			matrix.SetRow(3, new Vector4(0f, 0f, 1f, 0f));

			// default
			// matrix.SetRow(0, new Vector4(1f, 0f, 0f, 0f));
			// matrix.SetRow(1, new Vector4(0f, 1f, 0f, 0f));
			// matrix.SetRow(2, new Vector4(0f, 0f, 1f, 0f));
			// matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));

			// orthographics
			// matrix.SetRow(0, new Vector4(1f, 0f, 0f, 0f));
			// matrix.SetRow(1, new Vector4(0f, 1f, 0f, 0f));
			// matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
			// matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));

			// perspective
			// matrix.SetRow(0, new Vector4(focalLength, 0f, 0f, 0f));
			// matrix.SetRow(1, new Vector4(0f, focalLength, 0f, 0f));
			// matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
			// matrix.SetRow(3, new Vector4(0f, 0f, 1f, 0f));

			return matrix;
		}
	}
}