package main

import (
	_ "embed"

	"github.com/sestrella/acm/cmd"
)

//go:embed version.txt
var version string

func main() {
	cmd.Execute(version)
}
