package main

import (
    "fmt"
    "github.com/hyperledger/fabric/core/chaincode/shim"
    pb "github.com/hyperledger/fabric/protos/peer"
    "encoding/json"
)

// Defined to implement chaincode interface
type Producer struct {
}

// Define our struct to store PCs in Blockchain, start fields upper case for JSON
type PC struct {
    Snumber string  // This one will be our key
    Serie string
    Others string
    Status string   // this will contain its status on the exchange
}

// Implement Init
func (c *Producer) Init(stub shim.ChaincodeStubInterface) pb.Response {
    return shim.Success(nil)
}

// Implement Invoke
func (c *Producer) Invoke(stub shim.ChaincodeStubInterface) pb.Response {

    // Get function name and args
    function, args := stub.GetFunctionAndParameters()

    switch function {
    case "createPC":
        return c.createPC(stub, args)
    case "updateStatus":
        return c.updateStatus(stub, args)
    case "queryDetail":
        return c.queryDetail(stub, args)
    case "queryStock":
        return c.queryStock(stub, args)
    case "queryCompleteStock":
        return c.queryCompleteStock(stub, args)
    default:
        return shim.Error("Functions: createPC, updateStatus, queryDetail, queryStock, queryCompleteStock")
    }
}

// createPC puts an available PC in the Blockchain
func (c *Producer) createPC(stub shim.ChaincodeStubInterface, args []string) pb.Response {

    if len(args) != 3 {
        return shim.Error("createPC arguments usage: Serialnumber, Serie, Others")
    }

    // A newly created computer is available
    pc := PC{args[0], args[1], args[2], "available"} 

    // Use JSON to store in the Blockchain
    pcAsBytes, err := json.Marshal(pc)

    if err != nil {
        return shim.Error(err.Error())
    }

    // Use serial number as key
    err = stub.PutState(pc.Snumber, pcAsBytes)

    if err != nil {
        return shim.Error(err.Error())
    }
    return shim.Success(nil)
}

// updateStatus handles sell and hand back
func (c *Producer) updateStatus(stub shim.ChaincodeStubInterface, args []string) pb.Response {
    if len(args) != 2 {
        return shim.Error("This function needs the serial number as argument")
    }

    // Look for the serial number
    v, err := stub.GetState(args[0])
    if err != nil {
        return shim.Error("Serialnumber " + args[0] + " not found ")
    }

    // Get Information from Blockchain
    var pc PC
    // Decode JSON data
    json.Unmarshal(v, &pc)

    // Change the status
    pc.Status = args[1] 
    // Encode JSON data
    pcAsBytes, err := json.Marshal(pc)

    // Store in the Blockchain
    err = stub.PutState(pc.Snumber, pcAsBytes)
    if err != nil {
        return shim.Error(err.Error())
    }

    return shim.Success(nil)
}

// queryDetail gives all fields of stored data and wants to have the serial number
func (c *Producer) queryDetail(stub shim.ChaincodeStubInterface, args []string) pb.Response {

    // Look for the serial number
    value, err := stub.GetState(args[0])
    if err != nil {
        return shim.Error("Serial number " + args[0] + " not found")
    }

    var pc PC
    // Decode value
    json.Unmarshal(value, &pc)

    fmt.Print(pc)
    // Response info
    return shim.Success([]byte(" SNMBR: " + pc.Snumber + " Serie: " + pc.Serie + " Others: " + pc.Others + " Status: " + pc.Status))
}

// queryStock give all stored keys in the database
func (c *Producer) queryStock(stub shim.ChaincodeStubInterface, args []string) pb.Response {

    // See stub.GetStateByRange in interfaces.go
    start, end := "",""

    if len(args) == 2 {
        start, end = args[0], args[1]
    } 

    // resultIterator is a StateQueryIteratorInterface
    resultsIterator, err := stub.GetStateByRange(start, end)
    if err != nil {
        return shim.Error(err.Error())
    }
    defer resultsIterator.Close()

    keys := ""
    // This interface includes HasNext,Close and Next
    for resultsIterator.HasNext() {
        queryResponse, err := resultsIterator.Next()
        if err != nil {
            return shim.Error(err.Error())
        }
        keys+=queryResponse.Key + "\n"
    }

    fmt.Println("\n" + keys)

    return shim.Success([]byte(keys))
}

// queryCompleteStock give all stored values in the database
func (c *Producer) queryCompleteStock(stub shim.ChaincodeStubInterface, args []string) pb.Response {

    // See stub.GetStateByRange in interfaces.go
    start, end := "",""

    if len(args) == 2 {
        start, end = args[0], args[1]
    } 

    // resultIterator is a StateQueryIteratorInterface
    resultsIterator, err := stub.GetStateByRange(start, end)
    if err != nil {
        return shim.Error(err.Error())
    }
    defer resultsIterator.Close()

    values := ""
    // This interface includes HasNext,Close and Next
    for resultsIterator.HasNext() {
        queryResponse, err := resultsIterator.Next()
        if err != nil {
            return shim.Error(err.Error())
        }
        var pc PC
        json.Unmarshal(queryResponse.Value, &pc)
        values+= fmt.Sprintf("\n%v", pc)
    }

    fmt.Println("\n" + values)

    return shim.Success([]byte(values))
}

func main() {
    err := shim.Start(new(Producer))
    if err != nil {
        fmt.Printf("Error starting chaincode sample: %s", err)
    }
}
