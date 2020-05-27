using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum GizmoType
{
    SpawnPoint,
    Waypoint,
    SurfaceZone
}

public class GizmoDrawer : MonoBehaviour
{
    [SerializeField]
    GizmoType gizmoType;

    private void OnDrawGizmos()
    {
        switch(gizmoType)
        {
            case GizmoType.SpawnPoint:
                Gizmos.color = Color.green;
                Gizmos.DrawSphere(transform.position, 0.5f);
                Gizmos.color = Color.red;
                Gizmos.DrawLine(transform.position, transform.position + transform.forward);
                break;

            case GizmoType.Waypoint:
                Gizmos.color = Color.blue;
                Gizmos.DrawSphere(transform.position, 0.5f);
                break;

            case GizmoType.SurfaceZone:
                float alpha = 0.2f;
                switch(GetComponent<SurfaceZone>().GetSurfaceType())
                {
                    case SurfaceType.Concrete: Gizmos.color = new Color(0.3f, 0.3f, 0.3f, alpha); break;
                    case SurfaceType.Wood: Gizmos.color = new Color(0.5f, 0.4f, 0.05f, alpha); break;
                    case SurfaceType.Metal: Gizmos.color = new Color(0.8f, 0.8f, 0.8f, alpha); break;
                    default: Gizmos.color = new Color(0.9f, 0.05f, 0.05f, alpha); break;
                }
                
                Gizmos.DrawCube(transform.position, GetComponent<BoxCollider>().size);
                break;

            default: break;
        }
    }
}
