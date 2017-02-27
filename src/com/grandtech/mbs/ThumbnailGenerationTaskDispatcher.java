package com.grandtech.mbs;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Hashtable;


public class ThumbnailGenerationTaskDispatcher {

	private static ThumbnailGenerationTaskDispatcher self;
	
	public static ThumbnailGenerationTaskDispatcher getInstance() {
		if (self == null)
			self = new ThumbnailGenerationTaskDispatcher();
		return self;
	}
	
	private ProcessBuilder builder;
	private Hashtable<String, Preset> presets;
	private boolean initialized = false;
	private String exePath;
	
	private ThumbnailGenerationTaskDispatcher() {
		builder = new ProcessBuilder();
		presets = new Hashtable<String, Preset>();
	}

	public void initialize(String exePath) {
		this.exePath = exePath;
		this.initialized = true;
	}

	class Preset {
		public final String seekTo, resolution, quality;
		public Preset( String seekTo, String resolution, String quality) {
			this.seekTo = seekTo;
			this.resolution = resolution;
			this.quality = quality;
		}
	}
	
	public Process dispatchTask(String presetName, String inputPath, String outputPath) {
		try {
			if(!initialized) throw new Exception();
		
			Preset preset = getPreset(presetName);
			if(preset != null)
			{
				builder.command(this.exePath, "-y",
					"-ss", 		preset.seekTo, 
					"-i", 		inputPath,
					"-r", 		"1", 
					"-vframes", "1",	
					"-s", 		preset.resolution,
					"-qcomp", 	preset.quality, 
					"-f", "image2", outputPath);
			}
			return builder.start();
			
		} catch (Exception e) {
			MBSLogger.logError(e);
			return null;
		}
	}
	public void addPreset(String name, String seekTo, String resolution, String quality){
		presets.put(name, new Preset(seekTo, resolution, quality));
	}
	
	private Preset getPreset(String name){
		if(presets.containsKey(name))
			return presets.get(name);
		else
			return null;
	}
	public int generateThumbnail(String exePath, String inputPath, String outputPath, 
			String seekTo, String resolution, String quality){
	
		MBSLogger.log("[ThumbnailGenerator][generateThumbnail] called for sid:");
		
		Process proc = null;
		
		ProcessBuilder pb = new ProcessBuilder(
				exePath, "-y",
				"-ss", seekTo, 
				"-i", inputPath,
				"-r", "1", "-vframes", "1",
				"-s", resolution,
				"-qcomp", quality,
				"-f", "image2", outputPath);
		try {
			proc = pb.start();
			
			String tmpStr = "";
			String consoleOutput = "";
			
			BufferedReader br = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
			while((tmpStr = br.readLine()) != null){
				consoleOutput += tmpStr;
			}
			if(proc.waitFor() == ReturnCode.NO_ERROR.value) {
				MBSLogger.log("testRunExe end");
				return proc.exitValue();
			} else {
				MBSLogger.log(consoleOutput);
				return ReturnCode.ERROR_DEFAULT.value;
			}
		} catch (Exception e) {
			MBSLogger.logError(e);
			return ReturnCode.ERROR_DEFAULT.value;
		}
	}
}
