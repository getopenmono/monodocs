# Object Oriented coding for C programmers 

**I this guide I will introduce C++ concepts like objects and classes. We shall also look at other non-C features such as namespaces and operator overloads.**

### Who should read this?

Anyone who know C, but does not have a firm idea / experience with object oriented languages. You might have coded some Arduino sketches, but never really ventured further than `setup` and `loop`. If so, this guide is for you. Even if you know object oriented programming (OOP) from other languages like Java, C#, Objective-C etc. Then, you could familiarize yourself with the C++ syntax, by reading this guide.

## What is Objects?

The concept of *Object Oriented Programming* (OOP) was conceived at Xerox PARC in the 1970's. (It properly happened in a nice meeting room, with comfortable *beanbag* chairs.) OOP is a way of structuring your code, to make it more understandable. The idea is to logically group data and functionality together.

To do so OOP contains what we call a `class`. A class is a description of a data representation with associated functionality. We could easily describe a class i C by using the struct type:

```
struct Animal
{

}
```

An object is some data representation with associated functions.





For example if we have the following structure in C:

```
struct mono_model
{
	char *model_name;
	bool has_wifi;
	bool has_touch;
	int price;
	int version;
};
```

On C it is great to group data in `struct`'s, because it allows us to manage it easily. We could put them into an array or pass it to a function:

```
struct mono_model list_of_models[10];

void hasWifiAndTouch(struct mono_model *mono)
{
	return mono->has_wifi && mono->has_touch;
}
```

You properly done something similar in C, when working with structures. You might even have put function pointers into the structs. Basically *objects* in C++ is `struct`'s with attached functions.





<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
<link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/github.min.css">
<script>
  hljs.initHighlightingOnLoad();
</script>