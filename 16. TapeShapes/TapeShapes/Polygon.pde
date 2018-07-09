public class Polygon{
  private List<PVector> vertices;

  public Polygon(List<PVector> vertices){
    this.vertices = vertices;
  }

  public List<PVector> getSortedVertices(){
    final PVector center = getCenterPoint();
    // vertices.sort((PVector v1, PVector p2) -> {
    //   PVector centerToV1 = PVector.sub(v1,center);
    //   PVector centerToV2 = PVector.sub(v2,center);
    //   return centerToV1.heading() - centerToV2.heading();
    // });
    Collections.sort(vertices, new Comparator<PVector>(){
      public int compare(PVector v1, PVector v2){
        PVector centerToV1 = PVector.sub(v1,center);
        PVector centerToV2 = PVector.sub(v2,center);
        return centerToV1.heading() > centerToV2.heading() ?
          1 : centerToV1.heading() < centerToV2.heading() ? -1 : 0;
      }
    });
    return vertices;
  }

  private PVector getCenterPoint(){
    PVector centerPoint = new PVector(0, 0);
    for(PVector vertexVector : vertices)
      centerPoint.add(vertexVector);
    centerPoint.div(vertices.size());
    return centerPoint;
  }
}
