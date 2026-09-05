/// Synthetic, deterministic documents. No remote resources or copied articles.
Map<String, String> fixtures({int scale = 1}) => {
      'article': List.generate(
          180 * scale,
          (i) => '''
<h2>Section $i: local history</h2>
<p>A repeatable article contains <b>emphasis</b>, <i>detail</i> and
<a href="#section">internal references</a>. ${'The river winds past the old town and its quiet gardens. ' * 12}</p>
<blockquote>Observation $i: compare identical content on identical devices.</blockquote>
''').join(),
      'table':
          '<table border="1">${List.generate(300 * scale, (i) => '<tr>${List.generate(8, (j) => '<td>Row $i column $j</td>').join()}</tr>').join()}</table>',
      'lists': List.generate(
              100 * scale,
              (i) =>
                  '<ul><li>Group $i<ol>${List.generate(5, (j) => '<li>Item $j<ul><li>Nested detail</li><li>Another detail</li></ul></li>').join()}</ol></li></ul>')
          .join(),
      'images': List.generate(
              240 * scale,
              (i) =>
                  '<p>Local image $i</p><img src="asset:fixtures/tile.png" width="256" height="128" />')
          .join(),
    };
