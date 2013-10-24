Eventful App Example
====================

This is an example app that I have done that uses the Eventful service to search and display a list of events.

The app is fairy simple. However, because of the lack of a robust, non-bloated form builder and validation iOS library, I have spent sometime building a well architected form builder and form validation component using the Nimbus Table Models and CocoaReactive. 

```
//creates a form from a table view
EFForm *form = [[EFForm alloc] initWithTableView:tableView];

[form addFormElement:
             [EFTextInputFormElement textInputElementWithID:kFieldUniqueID placeholderText:@"PlaceHolder" value:@""]
    ];

[form.formValidator addValidator: 
        [EFFormValidatorRequired new],
	[EFFormAddressValidator new]	
	forElement:form[@(kFieldUniqueID)]

form.formValidator.delegate = formValidatorDelegate;

//non blocking call and returns right away
//the delegate methods will be called on the main thread
[form validate];

```

Setting up and Running the App
==============================
The app uses CocoaPod for dependancy management so you need to have that installed.
Visit http://cocoapods.org/ for the installation

`git clone https://github.com/asanieyan/eventful-app-example`
`cd eventful-app-example`
`pod install`

Wait until everything is installed and then run the iPhone Simulator.

Unit Tests
==========
I am using RestKit for making Restful API calls to the Eventful server. Restkit relies on AFNetworking. I couldn't stub the AFNetworking as it has a very complex operation. However for the sake of unit testing my objects, I have created a simple node server that would load the fixtures. To run the node server you need to have node.js installed first and then type `node server.js`

The server listens to the localhost:8080.
