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

type Data struct {
	Prefecture string `json:prefecture`
	Count	int `json:count`
}


func main(){

	Env_load()
	api := getTwitterApi()

	dt := time.Now()
	date := dt.Format("2006-01-02")

	prefectures_kanji := [...]string{"北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城",
								 "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", 
								"石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", 
								"兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川",
								"愛媛", "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄",
							}

	prefectures_roma := [...]string{"hokkaido", "aomori", "iwate", "miyagi", "akita", "yamagata", "fukushima", "ibaraki",
							"tochigi", "gunma", "saitama", "chiba", "tokyo", "kanagawa", "niigata", "toyama", 
						   "ishikawa", "fukui", "yamanashi", "nagano", "gifu", "sizuoka", "aichi", "mie", "siga", "kyoto", "osaka", 
						   "hyogo", "nara", "wakayama", "tottori", "shimane", "okayama", "hiroshima", "yamaguchi", "tokushima", "kagawa",
						   "ehime", "kouchi", "fukuoka", "saga", "nagasaki", "kumamoto", "oita", "miyazaki", "kagoshima", "okinawa",
						}


	v := url.Values{}
	v.Set("count", "100")
	
	var datas []Data

	for ind, prefetcutre := range prefectures_kanji {
		keyword := "タピオカ " + prefetcutre + " since:" + date
		searchResult, _ := api.GetSearch(keyword, v);
		var data Data
		data.Prefecture = prefectures_roma[ind]
		data.Count = len(searchResult.Statuses)
		datas = append(datas, data)
	}

	fmt.Println(datas)



	/*
//	count := 0
	searchResult, _ := api.GetSearch(keyword, v)
	for _ , tweet := range searchResult.Statuses {
		fmt.Println(tweet.CreatedAt);
	}

	fmt.Println(len(searchResult.Statuses))
*/

}