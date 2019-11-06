package main

import (
	"bytes"
	"github.com/tecbot/gorocksdb"
	"log"
)

func checkDB() {
	opts := gorocksdb.NewDefaultOptions()
	defer opts.Destroy()
	opts.SetCreateIfMissing(true)
	db, err := gorocksdb.OpenDb(opts, "/tmp/db")
	if err != nil {
		log.Fatalf("error openning DB %v", err)
	}
	if err := db.Put(gorocksdb.NewDefaultWriteOptions(), []byte("key"), []byte("value")); err != nil {
		log.Fatalf("error writing to DB %v", err)
	}
	if data, err := db.Get(gorocksdb.NewDefaultReadOptions(), []byte("key")); err != nil {
		log.Fatalf("error reading from DB %v", err)
	} else {
		if !bytes.Equal(data.Data(), []byte("value")) {
			log.Fatalf("unexpected output from DB %v", data.Data())
		}
	}
	db.Close()
}

func main() {
	checkDB()
}
