package main

import (
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	ex, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}
	dir := filepath.Dir(ex)
	scriptPath := filepath.Join(dir, "Start_Filewatcher.sh")

	cmd := exec.Command(scriptPath)
	cmd.Args = append(cmd.Args, os.Args[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}