package main
import (
  "net/http"
    "fmt"
    "os"
)

func sayHello(w http.ResponseWriter, r *http.Request) {
	name, err := os.Hostname()
	if err != nil {
		panic(err)
	}
	fmt.Fprintf(w, "hostname: " + name + "\n") 
}

func main() {
  http.HandleFunc("/", sayHello)
  if err := http.ListenAndServe(":80", nil); err != nil {
    panic(err)
  }
}
