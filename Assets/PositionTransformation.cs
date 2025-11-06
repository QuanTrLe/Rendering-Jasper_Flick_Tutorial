using UnityEngine;

public class PositionTransformation : Transformation {

    public Vector3 position;

    // overriding the abstract class func
    // in our specific case do transformation / positioning
    public override Matrix4x4 Matrix {
		get {
			Matrix4x4 matrix = new Matrix4x4();
			matrix.SetRow(0, new Vector4(1f, 0f, 0f, position.x)); // fill each row by one
			matrix.SetRow(1, new Vector4(0f, 1f, 0f, position.y));
			matrix.SetRow(2, new Vector4(0f, 0f, 1f, position.z));
			matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f)); // last one jsut identity
			return matrix;
		}
	}
}