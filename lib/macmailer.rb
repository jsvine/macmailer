#!/usr/bin/env ruby
# The MacMailer module lets you create, and send, emails 
# through OSX's Mail.app program. At its core, MacMailer 
# just writes and executes a temporary AppleScript script.
module MacMailer
	# Message is the main MacMailer class.
	class Message
		# Creates a MacMailer::Message instance. `props` can be left blank
		# for a blank message, but you'll probably want to pass along some
		# details. Valid keys for `props` include:
		#
		# 	:subject => String
		# 	:body => String
		# 	:recipients => Array (of hashes)
		#
		# Each hash in :recipients supports the following keys:
		#
		# 	:address => String
		# 	:name => String
		# 	:type => :to, :cc, or :bcc
		def initialize (props={})
			@props = props
		end

		# Creates an email, based on `@props`, using AppleScript. 
		# Does not send the email unless the optional `send` parameter 
		# is set to `true`.
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

		# Convenience method to create *and* send the message.
		def send
			self.create(send=true)
		end

		# Brings Mail.app to the front, using AppleScript.
		def show
			`/usr/bin/osascript > /dev/null <<MACMAILERSCRIPT
				tell application "Mail"
					activate
				end tell
			\nMACMAILERSCRIPT`
			self
		end

		# Helper method to write the AppleScript command to add
		# a new recipient to a message.
		private
		def _make_recipient (address, name, type)
			"make new #{(type || :to).to_s} recipient with properties " + 
			"{name:#{(name || address || "").dump}, address:#{(address || "").dump}}"
		end
	end
end
