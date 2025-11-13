using UnityEngine;

public class ScaleTransformation : Transformation {

    public Vector3 scale = new Vector3(1.0f, 1.0f, 1.0f);

    // overriding the abstract class func
    // in our specific case do transformation / positioning
    public override Matrix4x4 Matrix {
			get {
			Matrix4x4 matrix = new Matrix4x4();
			matrix.SetRow(0, new Vector4(scale.x, 0f, 0f, 0f)); // fill one by one
			matrix.SetRow(1, new Vector4(0f, scale.y, 0f, 0f)); // each one a const to mult an identity matrix to
			matrix.SetRow(2, new Vector4(0f, 0f, scale.z, 0f));
			matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));
			return matrix;
		}
	}
}