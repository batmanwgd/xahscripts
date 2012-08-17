import java.util.*;

/*

*/

public class comb {

    static HashMap combo (int n) {
        HashMap result = new HashMap(100);
        for (int j=1; j <= n; j++) {
            for (int i=1; i < j; i++) {
                int[] v= {i,j}; // for holding pairs
                result.put(i+ ","+j, v);
            }
        }
        return result;
    }

    static HashMap reduce (HashMap pairings, int[] pair) {
        int[] k= new int[2];
        int[] j= pair;
        HashMap newP = new HashMap(pairings); // make a copy to work with inside destructive loop
        newP.remove(j[0]+","+j[1]);
        for (Iterator it=pairings.values().iterator(); it.hasNext(); ){
            k = (int[]) it.next();
            if (k[0]==j[0]) {
                if (j[1] < k[1]) {
                    newP.remove(j[1]+","+k[1]);
                }
                else {
                    newP.remove(k[1]+","+j[1]);
                }
            }
            if (k[1]==j[0]) {
                if (k[0] < j[1]) {
                    newP.remove(k[0]+","+j[1]);
                } 
                else {
                    newP.remove(j[1]+","+k[0]);
                }
            }
        }
        return newP;
    }

    public static void main(String[] args) {
        HashMap result = new HashMap(100);
        HashMap result2 = new HashMap(100);
        int[] pair= {2,3};
        result = combo(5);
        System.out.println(result.keySet().toString());
        System.out.println( reduce(result, pair).keySet().toString());
    }
}

/*
%20girzu/skami_bangu/java/java_tutorial/tutorial/collections/interfaces/map.html



*/