package main

import "bytes"
import "fmt"
import "os"
import "os/exec"
import "io/ioutil"
import "io"
import "path"

var inkscapeBin = "inkscape"
var force = false

func isOlder(src string, than string) bool {
	if force {
		return false
	}
	stat, err := os.Stat(src)

	// If the file does not exist, it is not older.
	if os.IsNotExist(err) {
		return false
	}

	statThan, _ := os.Stat(than)

	return stat.ModTime().After(statThan.ModTime())
}

func copy(src, dst string) (int64, error) {
	sourceFileStat, err := os.Stat(src)
	if err != nil {
		return 0, err
	}

	if !sourceFileStat.Mode().IsRegular() {
		return 0, fmt.Errorf("%s is not a regular file", src)
	}

	source, err := os.Open(src)
	if err != nil {
		return 0, err
	}
	defer source.Close()

	destination, err := os.Create(dst)
	if err != nil {
		return 0, err
	}
	defer destination.Close()
	nBytes, err := io.Copy(destination, source)
	return nBytes, err
}

func prepare(folder string, f func(string, string)) {
	os.MkdirAll(cwd()+out+"/"+folder, os.ModePerm)
	items, _ := ioutil.ReadDir(folder)
	for _, item := range items {
		if item.IsDir() {
			os.MkdirAll(cwd()+out+"/"+folder+item.Name()+"/", os.ModePerm)
			prepare(folder+item.Name()+"/", f)
		}
		var src = cwd() + folder + item.Name()
		var dst = cwd() + out + "/" + folder + item.Name()
		f(src, dst)
	}
}

func toString(fs []string) string {
	var b bytes.Buffer
	for _, s := range fs {
		fmt.Fprintf(&b, "%s ", s)
	}
	return b.String()
}

var mode = "release"
var out = ""

func cwd() string {
	cwd, err := os.Getwd()
	if err != nil {
		panic(err.Error())
	}
	cwd += "/"
	return cwd
}

func currentDir() string {
	cwd, err := os.Getwd()
	if err != nil {
		panic(err.Error())
	}
	return path.Base(cwd)
}

func checkExecutable(bin string) {
	path, err := exec.LookPath(bin)
	if err != nil {
		fmt.Println(fmt.Sprintf("Could not find executable '%s'", bin))
		os.Exit(1)
	}
	fmt.Println(fmt.Sprintf("Found '%s' -> '%s'", bin, path))
}

func getMode() string {
  var args = os.Args
  if len(args) > 1 {
		return args[1]
  }
  return ""
}

func main() {
	fmt.Println("Building...")

	checkExecutable(inkscapeBin)
	mode = getMode()
	
  var args = os.Args
	if len(args) > 2 {
		force = true
	}

	if mode != "debug" && mode != "release" && mode != "print" {
		fmt.Println("Mode must be either 'debug' or 'release' or 'print'.")
		return
	}

	compileOptions := ""
	if mode == "print" {
		compileOptions = `\def\forprint{}`
		mode = "release"
	}

	outputDirName := "out"
	out = outputDirName + "/" + mode
	os.MkdirAll(out, os.ModePerm)

	bin := "lualatex"
	// arg3 := "-shell-escape"
	arg0 := "-output-directory"
	arg1 := outputDirName
	arg2 := `\def\base{` + out + `} ` + compileOptions + ` \input{src/book.tex}`
	fmt.Println(bin, arg0, arg1, arg2)

	out, err := exec.Command(bin, arg0, arg1, arg2).CombinedOutput()

	if err != nil {
		fmt.Println("%s %s", string(out), err)
  }

  // Rename
  var src = outputDirName + "/book.pdf"
  var dst =  outputDirName + "/" + currentDir() + "_" + getMode() + ".pdf"
	os.Rename(src, dst)

}
