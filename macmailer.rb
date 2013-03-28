#!/usr/bin/env ruby

# Main library, see bottom of file for example usage.
module MacMailer
	class Message
		def initialize (props)
			@props = props
		end

		def _make_recipient (address, name, type)
			"make new #{(type || :to).to_s} recipient with properties " + 
			"{name:#{(name || address || "").dump}, address:#{(address || "").dump}}"
		end

		# Convert message properties into AppleScript pass it to osascript
		def create (send=false)
			script = <<-SCRIPT
			tell application "Mail"
				set msg to make new outgoing message with properties {subject:#{(@props[:subject] || "").dump}, content:#{(@props[:body] || "").dump}, visible:true}
				tell msg
					#{(@props[:recipients] || []).map {|x| _make_recipient(x[:address], x[:name], x[:type]) }.join("\n") }
					#{send ? "send" : ""}
				end tell
			end tell
			SCRIPT
			@shell_response = `/usr/bin/osascript > /dev/null <<MACMAILERSCRIPT
				#{script}
			\nMACMAILERSCRIPT`
			self
		end

		# Create the message, and also automatically send it
		def send
			self.create(send=true)
		end

		# Bring Mail.app to the front
		def show
			`/usr/bin/osascript > /dev/null <<MACMAILERSCRIPT
				tell application "Mail"
					activate
				end tell
			\nMACMAILERSCRIPT`
		end
	end
end

# Commandline interface
if __FILE__ == $0
	require "trollop"
	recipient_note = "either as just an address, or an address followed by a name. Can be declared multple times."
	opts = Trollop::options do
		opt :subject, "Subject line.", :short => "-s", :type => :string
		opt :body, "Body.", :short => "-b", :type => :string
		opt :to, "Specify a To: recepient, #{recipient_note}", :multi => true, :type => :strings
		opt :cc, "Specify a CC: recepient, #{recipient_note}", :multi => true, :type => :strings
		opt :bcc, "Specify a BCC: recepient, #{recipient_note}", :multi => true, :type => :strings
		opt :send, "Automatically send the email. If not specified, script only creates the email."
		opt :show, "Bring Mail.app to the front of your screen. Otherwise, remains in background."
		opt :thanks, "Write Jeremy a note. (Note: Does *not* auto-send message. Overrides all other options.)"
	end

	# Send thanks and exit if "--thanks" flag is provided
	eval(DATA.read) if opts[:thanks]
		
	# Otherwise, create and/or send the message
	recipient_types = [ :to, :cc, :bcc ]
	def opt_to_recipients (multi, type)
		multi.map {|m| { :address => m.shift, :name => m.join(" "), :type => type } }
	end
	
	message = MacMailer::Message.new({
		:subject => opts[:subject],
		:body => opts[:body],
		:recipients => recipient_types.map do |sym|
			opt_to_recipients(opts[sym], sym)
		end.flatten(1)
	}).method(opts[:send] ? :send : :create).call
	message.show if opts[:show]
end

__END__
MacMailer::Message.new({
	:subject => "re. MacMailer",
	:body => "Thanks! It's freaking awesome.",
	:recipients => [
		:address => "jsvine@gmail.com",
		:name => "Jeremy Singer-Vine"
	]
}).create.show
exit
