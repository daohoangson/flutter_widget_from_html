<?php

$dirPath = 'packages/example/test/images';
$extension = 'png';
$globPath = realpath(__DIR__ . "/../../$dirPath");
$imagePaths = glob("$globPath/*.$extension");
$tagImages = [];
foreach ($imagePaths as $imagePath) {
  $basename = basename($imagePath);
  $withoutExt = preg_replace("/\.$extension\$/", '', $basename);
  $tags = explode(',', $withoutExt);
  foreach ($tags as $tag) {
    $tagImages[$tag] = $basename;
  }
}

echo "|   | Tag | Demo |\n| - | --- | ---- |\n";
$tags = array_keys($tagImages);
for ($i = 0; $i < count($tags); $i++) {
  $no = $i + 1;
  $tag = $tags[$i];
  $basename = $tagImages[$tag];

  echo "| $no | $tag | ![](https://github.com/daohoangson/flutter_widget_from_html/raw/master/$dirPath/$basename) |\n";
}
