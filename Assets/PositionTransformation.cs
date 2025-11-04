using UnityEngine;

public class PositionTransformation : Transformation {

    public Vector3 position;

    // overriding the abstract class func
    // in our specific case do transformation / positioning
    public override Vector3 Apply(Vector3 point)
    {
        return point + position;
    }
}