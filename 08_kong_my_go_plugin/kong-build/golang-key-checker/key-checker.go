package main
import (
   "github.com/Kong/go-pdk"
)

//Next, I’ll create a struct for configuration to represent the config parameters in the config.yaml config file.
type Config struct {
   Apikey string
}

//We need to add a function called "New."" Doing this returns an interface.
func New() interface{} {
   return &Config{}
}

func (conf Config) Access(kong *pdk.PDK) {
	key, err := kong.Request.GetQueryArg("key")
	apiKey := conf.Apikey
	if err != nil {
		kong.Log.Err(err.Error())
	}

	kong.Response.AddHeader("Server", "NUTSU")

	x := make(map[string][]string)
   	x["Content-Type"] = append(x["Content-Type"], "application/json")
   	if apiKey != key {
       kong.Response.Exit(403, "You have no correct key", x)
   	}

}