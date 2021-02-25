# -*- coding: utf-8 -*-

import time
from mycroft.skills.core import MycroftSkill, intent_file_handler
from mycroft.messagebus.message import Message
from mycroft.util.log import LOG

__author__ = 'aix'

class TWCStream(MycroftSkill):
    def __init__(self):
        super(TWCStream, self).__init__(name="TWCStream")

    def initialize(self):
        LOG.info("Initialized")
        self.bus.on('twcstream.aiix.home', self.play_twc_live_stream)

    # Create an intent for playing Sky News Live Stream
    # Lets use a intent file to be able to call this function
    
    def launcher_id(self, message):
        self.prepare_homepage({})
        
    def prepare_homepage(self, message):
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        self.gui["loadingStatus"] = ""
        self.gui.show_page("StreamLogo.qml", override_idle=True)
        time.sleep(4)
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        self.play_sky_live_stream({})
    
    @intent_file_handler("play_twc_live_stream.intent")
    def play_twc_live_stream(self, message):
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        # Get the URL of where the live stream is playing
        set_url = "https://weather-lh.akamaihd.net/i/twc_1@92006/master.m3u8"
        # Sending the stream to my GUI, creating a sessionData object
        self.gui["videoState"] = "Play"
        self.gui["videoStream"] = set_url
        # This is the session data that is being sent to the qml page
        # Asking the skill to display a page that will contain my video player
        # Let's create the qml user interface for this
        self.gui.show_page("TWCStream.qml", override_idle=True)
    
    @intent_file_handler("stop_twc_live_stream.intent")
    def stop_twc_live_stream(self, message):
        self.gui["videoState"] = "Stop"
        
def create_skill():
    return TWCStream()
