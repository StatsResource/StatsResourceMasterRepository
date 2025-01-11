Huffman Encoding Compression Algorithm
===================================

By Alex Allain The Huffman encoding algorithm is an optimal compression algorithm when only the frequency of individual letters are used to compress the data. (There are better algorithms that can use more structure of the file than just letter frequencies.) The idea behind the algorithm is that if you have some letters that are more frequent than others, it makes sense to use fewer bits to encode those letters than to encode the less frequent letters. 

For instance, take the following phrase: "ADA ATE APPLE". There are 4 As, 1 D, 1 T, 2 Es, 2 Ps, 1 L, and 2 spaces. There are a few ways that might be reasonable ways of encoding this phrase using letter frequencies. First, notice that there are only a very few letters that show up here. It would be silly to use chars, with eights bits apiece, to encode each character of the string. In fact, given that there are only seven characters, we could get away with using three bits for each character! If we decided to simply take that route, that would require using 14 * 3 bits, for a total of 42 bits (and some extra padding for the sake of having correct bit-alignment since you have to use an entire byte). That's not too bad! It's a lot better than the 8 * 14 = 112 bits that would otherwise be required. 

But we can do even better if we consider that if one character shows up many times, and several characters show up only a few times, then using one bit to encode one character and many bits to encode another might actually be useful if the character that uses many bits only shows up a small number of times!
Prefix Property

To get away with doing this, we now need a way of knowing how to tell which encoding matches which letter. For instance, before, we knew that every three (or eight bits) was a boundary for a letter. Now, with different length encodings for different letters, we need to have some way of separating the words out. For instance, given the string 001011100, if we know that every letter is encoded with three bits, it's easy to break apart into 001 011 100. If some letters are encoded with one bit, and another with four, it's not as easy to know how to do it. 

But we can use a trick commonly referred to as the "prefix property". The idea is that the encoding for any one character isn't a prefix for any other character. For instance, if A is encoded with 0, then no other character will be encoded with a zero at the front. That way, if we start reading a string of bits and the first bit is a zero, we know that we can stop reading, and we know that bit encodes an A because no other character encoding begins with a 0. In general, the idea is that if we have a full encoding for a character, then that encoding won't show up at the beginning of the encoding for any other character. This means that once we actually read a string of bits that match a particular character, we know that it must mean that that's the next character and we can start fresh from the next bit, looking for a new character encoding match. 

Note that it is perfectly fine for the encoding for a character to show up in the middle of the encoding for another character because there's no way we'd mistake that as the encoding for another character so long as we start decoding from the first bit in the compressed file. (On the other hand, if we get off by a bit, this might cause some headaches.) 

Let's take a look at how this might actually work using some simple encodings that all have the property that the encoding for one character doesn't show up at the beginning of the encoding for another character.
char  encoding
A     0
E     10
P     110
space 1110
D     11110
T     111110
L     111111
This is a pretty simple encoding, but it does match the prefix property -- the encoding for A doesn't show up at the front of any other encoding, nor does the encoding for B, and so forth. (Some of the encodings share the same prefix, but that's perfectly fine because we can always tell them apart at some point by reading in more bits.) 

For instance, the original string we had could be encoded by
011110011100111110101110011011011111110 (39 bits)
which we could break apart as
0 11110 0 1110  0 111110 10 1110  0 110 110 111111 10
A D     A Space A T      E  Space A P   P   L      E
Notice that even using this somewhat simple approach to generating encodings that satisfy the prefix property, we managed to save 4 bits over the approach of using 3 bits per character. With even more unbalanced word frequencies, we could do even better. 

A nice way of visualizing the process of decoding a file compressed with Huffman encoding is to think about the encoding as a binary tree, where each leaf node corresponds to a single character. At each inner node of the tree, if the next bit is a 0, move to the left node, otherwise move to the right node. 

For instance, the prefix encoding used above would have a binary tree representation that looks like this -- the X's indicate inner nodes.
       X
      / \
     /   \
    A     X
         / \
        /   \
       E     X
            / \
           /   \ 
          P     X
               / \
              /   \
             Space X
                  / \
                 /   \
                D     X
                     / \
                    /   \
                   T     L
To decode the string, all we do is follow the links of the tree until we hit a leaf node. Once a leaf node is reached, we output the character stored at the leaf and go back up to the root of the tree.
The Huffman Algorithm

So far, we've gone over the basic principles we'll need for the Huffman algorithm, both for encoding and decoding, but we've had to guess at what would be the best way of actually encoding the characters. For our simple text string, it wasn't too hard to figure out a decent encoding that saved a few bits. But in the general case, it might be hard to figure out a good solution, let alone the best possible solution. 

The Huffman algorithm is a so-called "greedy" approach to solving this problem in the sense that at each step, the algorithm chooses the best available option. It turns out that this is sufficient for finding the best encoding. 

The basic idea behind the algorithm is to build the tree bottom-up. First, every letter starts off as part of its own tree and the trees are ordered by the frequency of the letters in the original string. Then the two least-frequently used letters are combined into a single tree, and the frequency of that tree is set to be the combined frequency of the two trees that it links together. 

For instance, if we started out with two characters that showed up once, L and T, in our sample string, they would be recombined into a new tree that has a "supernode" that links to both L and T, and has a frequency of 2:

   X, 2
   / \
  /   \
 L, 1  T, 1

This new tree is reinserted into the list of trees in its sorted position. The process is then repeated, treating trees with more than one element the same as any other trees except that their frequencies are the sum of the frequencies of all of the letters at the leaves. (This is just the sum of the left and right children of any node because each node stores the frequency information about its own children.) The process completes when all of the trees have been combined into a single tree -- this tree will describe a Huffman compression encoding. 

Essentially, a tree is built from the bottom up -- we start out with 256 trees (for an ASCII file) -- and end up with a single tree with 256 leaves along with 255 internal nodes (one for each merging of two trees, which takes place 255 times). The tree has a few interesting properties -- the frequencies of all of the internal nodes combined together will give the total number of bits needed to write the encoded file (except the header). This property comes from the fact that at each internal node, a decision must be made to go left or right, and each internal node will be reached once for each time a character beneath it shows up in the text of the document. 

To go from plain text to compressed text, you would have to do a traversal of the tree and store the path to reach each leaf node as a string of bits (0 for going left, 1 for going right) and associate that bit with the particular character at the leaf. Once this is done, converting a plain text file into a compressed file is just a matter of replacing each letter with an appropriate bit string and then handling the possibility of having some extra bits that need to be written (this is discussed more fully in the implementation notes). Notice that two different data structures likely need to be used here -- a list of trees, and those binary trees themselves. It might make sense to use several data structures such as:
struct tree_t
{
    tree_t *left;
    tree_t *right;
    char character;
};
to store the tree elements (note that if left and right are NULL, then we would know that the node is a leaf and that character stores a valid char of interest) and
struct list_t
{
    list_t *next;
    int total_frequency;
    tree_t *tree;
}
to store the list of trees that still need to be merged together as a linked list.
Implementation Notes

The first thing to realize is that when writing a compressed file, you will need to include a Huffman header that stores the letter frequencies in the original file so that the Huffman tree can be rebuilt by whoever is decoding the file. This could be something as simple as
struct huff_header
{
    char letters[256];
};
and you could use fread to read in the entire header at once. It wouldn't hurt to include a "magic number" at the beginning of your header so that your program can tell whether the file was actually compressed by your program. (This prevents the confusion of wondering if the garbage output is a result of a garbage plain text file, or if the file being decompressed wasn't actually created from a plain text file.) 

When implementing Huffman compression, remember that any one of many possible encodings may be valid, and the differences come about based on how you build up the tree. This means that both the compressor and decompressor will need to follow the same rules. In practice, it probably makes sense to use the same tree building code for both. 

Files are written in chunks of eight bits, but it's unlikely that you will have a file that, when compressed, turns out to need an exact multiple of eight bits. You'll have to add some extra junk at the end of the last byte you write to the file, and when decoding, you'll need some way of knowing when you've finished reading the valid bits and started reading the bits that were added as packing (which may or may not encode a character). One way of doing this would be to keep track of the number of letters decompressed so far and stop decoding the file when that limit has been reached.
