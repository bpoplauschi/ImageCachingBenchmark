ImageCachingBenchmark
=====================

Benchmark tests for iOS image caching solutions

## Benchmark detailed results
- [see here](http://htmlpreview.github.io/?https://github.com/bpoplauschi/ImageCachingBenchmark/blob/master/tables/tables.html)

## Conclusions

<table style="border:0px solid black; text-align:center; font-size:12px;">
<tbody>

<tr>
<th>Results</th>
<th>SDWebImage</th>
<th>FastImageCache</th>
<th>AFNetworking</th>
<th>TMCache</th>
<th>Haneke</th>
</tr>

<tr>
<td>async download</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>backgr decompr</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10007;</td>
</tr>

<tr>
<td>store decompr</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10007;</td>
</tr>

<tr>
<td>memory cache</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>disk cache</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>iOS7 NSURLCache</td>
<td>&#10003;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>GCD and blocks</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>easy to use</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>UIImageView categ</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>from memory</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>from disk</td>
<td>&#10007;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10007;</td>
</tr>

<tr>
<td>lowest CPU</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>lowest mem</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>


<tr>
<td>high FPS</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10003;</td>
<td>&#10007;</td>
<td>&#10003;</td>
</tr>

<tr>
<td>License</td>
<td>MIT</td>
<td>MIT</td>
<td>MIT</td>
<td>Apache</td>
<td>Apache</td>
</tr>

</tbody>
</table>
