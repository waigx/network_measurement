package org.igorw
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	public class ExecExternal extends EventDispatcher
	{
		//this is the excutable name
		public var name:String = "";	
		
		//Claim executable file parameters
		public var args:Vector.<String> = new Vector.<String>();
		public var output:String = "";
		
		private var process:NativeProcess;
		private var externalExec:File=new File();
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		
		public function ExecExternal(path:String, name:String="", autoQuit:Boolean = true)
		{
			NativeApplication.nativeApplication.autoExit = autoQuit;
			externalExec = externalExec.resolvePath(path);
			
			nativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = externalExec;
		}
		
		public function run():void
		{
			//dispatch run event;
			dispatchEvent(new Event(name+"_START"));
			process = new NativeProcess();
			
			//attach args to process
			nativeProcessStartupInfo.arguments = args;
			process.start(nativeProcessStartupInfo);
			
			//listen application quit event;
			process.addEventListener(NativeProcessExitEvent.EXIT, processExitDispatcher);
			process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, ouputHandler);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
		}
		
		protected function processExitDispatcher(event:NativeProcessExitEvent):void
		{
			dispatchEvent(new Event(name+"_EXIT"));
			process.removeEventListener(NativeProcessExitEvent.EXIT, processExitDispatcher);
		}
		
		
		protected function ouputHandler(event:Event):void
		{
			dispatchEvent(new Event(name+"_OUT_SUCCESS"));
		}
		
		protected function onOutputData(event:ProgressEvent):void
		{
			var data:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable); 
			output += data;
		}
		
		public function set execPath(path:String):void
		{
			//update to new executable file
			externalExec = externalExec.resolvePath(path);
			nativeProcessStartupInfo.executable = externalExec;
		}
		
		public function get isRunning():Boolean
		{
			//return current running status of the process
			if (process==null){
				return false;
			}
			return process.running;
		}
		
		public function stop():void
		{
			if (process!=null && this.isRunning){
				process.exit(true);
			}
		}
	}
}