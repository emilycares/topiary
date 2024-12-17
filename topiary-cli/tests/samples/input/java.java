package topiary;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.List;

@Path("/test")
public class GreetingResource {

  private class HIhi {}

  @Get
  Long other;

  @GET
  @Produces(MediaType.TEXT_HTML)
  public String hellos(String a) {
    String local = other.toString();
    List<String> names = List.of("a", "b");
    for(int i = 0; i < 5;i++) {
      for(String name : names) {
        names.stream().map((n) -> {
          return n + "_";
        });
      }
    }

    new Variable().hello();
    hello.data("");
    local.concat("");

    return "asdf";
  }
}
