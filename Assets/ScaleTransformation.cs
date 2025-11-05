using UnityEngine;

public class ScaleTransformation : Transformation {

    public Vector3 scale = new Vector3(1.0f, 1.0f, 1.0f);

    // overriding the abstract class func
    // in our specific case do transformation / positioning
    public override Vector3 Apply(Vector3 point)
    {
        point.x *= scale.x;
        point.y *= scale.y;
        point.z *= scale.z;
        return point;
    }
}