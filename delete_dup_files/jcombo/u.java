import java.util.*;

public class u {

    public static void main(String[] args) {
        HashMap result = new HashMap(100);
        HashMap result2 = new HashMap(100);
        int[] v= new int[2];

        for (int j=1; j <= 3; j++) {
            for (int i=1; i <= 3; i++) {
                v[0]=i;v[1]=j;
                result.put(String.valueOf(i)+ ","+ String.valueOf(j),v);
                result2.put(String.valueOf(i)+ ","+ String.valueOf(j),v);
            }
        }


        if (result.equals(result2)) {
            System.out.println("yea");
        }else{
            System.out.println("na");
        }
        System.out.println(result.toString());
        System.out.println(result2.toString());
    }
}
