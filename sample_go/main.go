package main

import (
	"log"
	"time"
)

func main() {
	log.Println("")
	log.Println("/")
	for {
		time.Sleep(time.Millisecond * 1000)
		log.Println("test")
	}
}
