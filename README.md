__MacMailer__ is a command-line utility and Ruby library for creating and sending messages in OSX's Mail.app program.


## Installation

`gem install macmailer`


## Command-Line Usage

You can create and send messages from the command-line with MacMailer. All flags are optional. So to create a blank message — it'll show up in Mail.app in the background — simply type:

	macmailer

To create a more complicated message, try:

	macmailer --subject "Hello, world." --body "Take me toooo... ComputerTowwwwwn." --to jsvine@gmail.com Jeremy Singer-Vine --cc jsvine+macmailer@gmail.com --bcc jsvine+spam@gmail.com

You can specify multiple recipients per field by issuing the same flag again. For example:

	macmailer --to jsvine@gmail.com --to jsvine+alterego@gmail.com

If you're absolutely sure you want to send your message without proofreading it, you can pass the --send flag:

	macmailer --subject "Autosending..." --to jsvine@gmail.com --send


## Library Usage

You can also integrate MacMailer into any Ruby program by adding  the following line to your code:

	require "macmailer"

For now, the only `MacMailer::Message` is the only class in the library. To populate a new Message instance:

	msg = MacMailer::Message.new({
		:subject => "She makes the sign of a teaspoon",
		:body => "He makes the sign of a wave",
		:recipients => [
			{ :address => "jsvine@gmail.com" },
			{ :address => "jsvine+cced@gmail.com", :type => :cc },
			{ :address => "jsvine+bcced@gmail.com", :name => "Jeremy", :type => :bcc }
		]
	})

To create a new Mail.app message from that instance:

	msg.create

Or, if you're absolutely sure you want to send the email before checking it:

	msg.send


## Just for Fun

	macmailer --thanks