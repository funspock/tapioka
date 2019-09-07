package main

import (
	"os"
    "fmt"
    "log"
	"github.com/joho/godotenv"
	"github.com/ChimeraCoder/anaconda"
	"net/url"
	"time"
)

func Env_load() {
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }
}

func getTwitterApi() *anaconda.TwitterApi {
    anaconda.SetConsumerKey(os.Getenv("API_KEY"))
    anaconda.SetConsumerSecret(os.Getenv("API_SECRET_KEY"))
    return anaconda.NewTwitterApi(os.Getenv("ACCESS_TOKEN"), os.Getenv("ACCESS_TOKEN_SECRET"))
}




func main(){

	Env_load()
	api := getTwitterApi()

	dt := time.Now()
	date := dt.Format("2006-01-02")

	keyword := "タピオカ since:" + date

	v := url.Values{}
	v.Set("count", "100")
	
	


//	count := 0
	searchResult, _ := api.GetSearch(keyword, v)
	for _ , tweet := range searchResult.Statuses {
		fmt.Println(tweet.CreatedAt);
	}

	fmt.Println(len(searchResult.Statuses))


}