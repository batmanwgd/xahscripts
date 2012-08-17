import java.util.*;


public class hasharray {
    static HashMap gen (int n) {
        HashMap result = new HashMap(100);

        for (int j=1; j <= n; j++) {
            for (int i=1; i < j; i++) {
                int[] v= new int[2]; // for holding pairs
                v[0]=i;v[1]=j;
                result.put(i+ ","+j, v);
            }
        }
        return result;
    }

    static HashMap prin (HashMap pairings) {
        int[] k= new int[2];
        for (Iterator it=pairings.values().iterator(); it.hasNext(); ){
            k = (int[]) it.next();
            System.out.println(k[0]+","+k[1]);
        }
        return pairings;
    }

    public static void main(String[] args) {
        HashMap result = new HashMap(100);
        result = gen(5);
        System.out.println(result.toString());
        prin(result);
        System.out.println(result.toString());
    }
}
