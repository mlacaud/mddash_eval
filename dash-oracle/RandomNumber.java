import java.math.BigDecimal;

public class RandomNumber {
  public static void main(String[] args) {
    double offset = new BigDecimal(Math.random())
    		    			.setScale(3, BigDecimal.ROUND_HALF_UP)
    		    			.doubleValue();

    System.out.println(offset*240);
  }
}
