import java.util.*;

public class comb {
    static HashMap combo (int n) {
        HashMap result = new HashMap(100);

        for (int j=1; j < n; j++) {
            for (int i=1; i <= n; i++) {
                int m = ((i+j)-1) % n +1;
                if (i < m){ 
                    int[] v= {i,m};
                    result.put(i+","+m,v);
                }
            }
        }
        return result;
    }

    public static void main(String[] args) {
        HashMap result = new HashMap(100);
        result = combo(5);
        System.out.println(result.toString());
    }
}

