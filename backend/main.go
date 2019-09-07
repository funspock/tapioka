package main

import (
	"os"
    "fmt"
    "log"
    "github.com/joho/godotenv"
)

func Env_load() {
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }
}


func main(){

	Env_load()
	api_key := os.Getenv("API_KEY")
	api_secret_key := os.Getenv("API_SECRET_KEY")
	access_token := os.Getenv("ACCESS_TOKEN")
	access_token_secret := os.Getenv("ACCESS_TOKEN_SECRET")

	fmt.Println(api_key)



}