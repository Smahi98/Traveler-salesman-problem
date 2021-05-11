

ArrayList<PVector> cities;                                        
int                citiesCount       = 6;
int                populationCount   = 6;

int[]              bestPath          = new int[citiesCount];
int[][]            population        = new int[populationCount][citiesCount];
double[]           distances         = new double[populationCount]; 
double[]           fitnesses         = new double[populationCount];

int                generation        = 0;


void setup(){
     size(1024,768);
     
     frameRate(15);
     /*     Generate random cities as 2D points     */
     cities = new ArrayList<PVector>(){{
          for(int i = 0; i < citiesCount; i++){
               add(new PVector((int)(Math.random()*width),(int)(Math.random()*height)));
               bestPath[i] = i;
          }
     }};
     
     /*     Generate random paths and calculates their distances     */
     population[0] = bestPath.clone();
     distances[0]  = distance(population[0]);
     fitnesses[0]  = 1/distances[0];
     for(int k = 1; k<populationCount; k++){
          population[k] = shuffle(bestPath, 10);
          distances[k] = distance(population[k]);
          fitnesses[k] = 1/distances[k];
     }
     
     /*     Normalize the fitness of each path     */
     double fSum = 0;
     for(int k = 0; k < populationCount; k++){
          fSum += fitnesses[k];
     }
     for(int k = 0; k < populationCount; k++){
          fitnesses[k] = fitnesses[k] / fSum;
     }
     
     
     /*     Print the data     */
     println("****************\t\t Generation 0 \t\t****************\n");
     println("Path \t\t -- \tDistance\t\t --\t Fitness ");
     for(int i = 0; i<populationCount; i++){
          for(int j = 0; j<citiesCount; j++){
               print(population[i][j]+" ");
          }
          print(" -- \t"+ distances[i] +"\t --\t "+ fitnesses[i]);
          println();
     }
     
}


void draw(){
    //noLoop();
     background(11,11,56);
     noFill();
     
     /*     Visualize the data and finds the best path     */
     for(int[] p: population){
          
          stroke((float)Math.random()*255, (float)Math.random()*255, 255, 5);
          
          beginShape();
          for(int k: p){
               vertex(cities.get(k).x, cities.get(k).y);
               
               text(k,cities.get(k).x+10,cities.get(k).y);
               ellipse(cities.get(k).x, cities.get(k).y, 10,10);
          }
          endShape(); 
          
          
     }
     
     /*     Highlight the best path     */
     stroke(255);
     strokeWeight(2);
     beginShape();
     for(int k: bestPath){
          vertex(cities.get(k).x, cities.get(k).y);
          ellipse(cities.get(k).x, cities.get(k).y, 10,10);
     }
     endShape(); 
     
     nextGen();
     infos();
     text("Generation : " + generation, 100,550);
     text("Shortest distance so far : " + distance(bestPath), 100,565);
}

/*     Shuffles an array n times      */
int[] shuffle(int[] array, int n){
     int[] arrayCopy = array.clone();
     for(int k = 0; k < n; k++)
          swapRandom(arrayCopy);
     return arrayCopy;
}

/*     Swaps two random indices of an array     */
int[] swapRandom(int[] array){
    int index1 = (int)(Math.random()*array.length);
    int index2;
    do{
         index2 = (int)(Math.random()*array.length);
    }while(index1 == index2);
    int temp = array[index1];
    array[index1] = array[index2];
    array[index2] = temp;
    return array; 
}

/*     Calculates the total distance of a path     */
double distance(int[] path){
     double result      = 0.0f;
     PVector lastVertex = cities.get(path[0]); 
     for(int k: path){
          result += euclidianDist(lastVertex, cities.get(k));
          lastVertex = cities.get(k);
     }
     return result;
}

/*     Calculates the Euclidian distance between two points     */
double euclidianDist(PVector A, PVector B){
     return Math.sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
}


/**/
int[] select(){
     double rnd = Math.random();
     int i = 0;
     while(rnd > 0){
          rnd -= fitnesses[i];
          i++;
     }
     i--;
     return population[i];
}

/**/
void nextGen(){
     int[][] nextPopulation = new int[populationCount][citiesCount];
     for(int k = 0; k < populationCount; k++){
          nextPopulation[k] = select().clone();
          mutate(nextPopulation[k]);
     }
     population = nextPopulation;
     generation++;
     
     
     distances[0]  = distance(population[0]);
     fitnesses[0]  = 1/distances[0];
     for(int k = 1; k < populationCount; k++){
          distances[k] = distance(population[k]);
          fitnesses[k] = 1/distances[k];
     }
     
     /*     Normalize the fitness of each path     */
     double fSum = 0;
     for(int k = 0; k < populationCount; k++){
          fSum += fitnesses[k];
     }
     for(int k = 0; k < populationCount; k++){
          fitnesses[k] = fitnesses[k] / fSum;
     }
     int[] newBestPath = population[0];
     for(int[] p: population){
          if(distance(p)<distance(newBestPath))
               newBestPath = p;
     }
     
     if(distance(bestPath)>distance(newBestPath))
               bestPath = newBestPath;
     
}

void mutate(int[] path){
     swapRandom(path);
}

void infos(){
     
     println("\t****** \t Generation "+generation+"\t ****** ");
     print("Path");
     for(int i = 0; i < 2*bestPath.length-3; i++)
          print(' ');
     println("-- \tDistance\t\t --\t Fitness ");
     for(int i = 0; i<populationCount; i++){
          for(int j = 0; j<citiesCount; j++){
               print(population[i][j]+" ");
          }
          print(" -- \t"+ distances[i] +"\t --\t "+ fitnesses[i]);
          println();
     }
     print("[ Best path so far ] \t");
     for(int j = 0; j<citiesCount; j++){
               print(bestPath[j]+" >> ");
     }
     println();
     println("\t** ** ** ** ** ** ** ** ** ** ** **");
     println();
     
}
