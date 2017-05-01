package edu.gatech.cse6242;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.util.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import java.io.IOException;

public class Q4 {

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();

    Job job1 = Job.getInstance(conf, "Q4_Job1");
    job1.setJarByClass(Q4.class);
    job1.setMapperClass(TokenizerMapper.class);
    job1.setCombinerClass(SumReducer.class);
    job1.setReducerClass(SumReducer.class);
    job1.setOutputKeyClass(Text.class);
    job1.setOutputValueClass(IntWritable.class);
    FileInputFormat.addInputPath(job1, new Path(args[0]));
    Path tempPath = new Path(args[1] + "_temp");
    FileOutputFormat.setOutputPath(job1, tempPath );
    boolean jobSuccess = job1.waitForCompletion(true);

    if (jobSuccess) {
      Job job2 = Job.getInstance(conf, "Q4_Job2");
      job2.setJarByClass(Q4.class);
      job2.setMapperClass(DataMapper.class);
      job2.setCombinerClass(SumReducer.class);
      job2.setReducerClass(SumReducer.class);
      job2.setOutputKeyClass(Text.class);
      job2.setOutputValueClass(IntWritable.class);
      FileInputFormat.addInputPath(job2, tempPath);
      FileOutputFormat.setOutputPath(job2, new Path(args[1]));
      jobSuccess = job2.waitForCompletion(true);
      System.exit( jobSuccess ? 0 : 1);
    } else {
      System.exit(1);
    }
  }

  public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {

    private Text source = new Text();
    private Text target = new Text();
    private IntWritable one = new IntWritable(1);

    public void map(Object key,
        Text value,
        Context context) throws IOException, InterruptedException {
      String line = value.toString();
      if (!line.isEmpty()) {
        String nodes[] = line.split("\t");
        source.set(nodes[0]);
        context.write(source, one);
        target.set(nodes[1]);
        context.write(target, one);
      }
    }
  }

  public static class SumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key,
        Iterable<IntWritable> values,
        Context context) throws IOException, InterruptedException {

      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }

  public static class DataMapper extends Mapper<Object, Text, Text, IntWritable> {

    private Text degree = new Text();

    public void map(Object key,
        Text value,
        Context context) throws IOException, InterruptedException {

      String line = value.toString();
      if (!line.isEmpty()) {
        String tokens[] = line.split("\t");
        degree.set(tokens[1]);
        context.write(degree, new IntWritable(1));
      }
    }
  }

}
