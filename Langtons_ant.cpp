#include <time.h>
#include <algorithm>

class Langtons_Ant{
  public:
    void print(char[] A){
      const int n = sizeof(A)/sizeof(A[0]);
      for(int i = 0; i < n; i++){
          for(int j = 0; j < n; j++){
                cout << A[i][j] << " ";
            }
        }
        cout << endl;
    }
}

int main(){
  
  return 0;
}
