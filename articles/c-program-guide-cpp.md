# The C programmers guide to C++

**In this article you will learn to use C++, if you previously have coded in Arduino or C. We will go through to fundamental C++ constructs and concepts.**

### Who should read this?

I assume that you are similiar with basic C, nothing fancy - just plain `main()` with function calling and *maybe* some pointer juggling. Also, if you have coded Arduino and are used to the concept there - this article is for you!

Read on, and we shall introduce the most basic concepts and headaches of C++.

## Overview

Allow me to start of with a brief introduction to C++. Back in the days it started it life as an extension to C. This means you still have access to all of C from C++.

C++ introduces a set of new language constructs on top of C, and also tighens some *type casting* rules that are looser in C.

In this article we will examine the following C++ features:

1. [Classes](#classes)
1. [Inheritance](#inheritance)
1. [Contructors & the rule of 3](#constructors)
1. [References](#references)
1. [Namespaces](#namespaces)
1. [Virtual methods](#virtual-methods)

Let's dive in.

## Classes

If you heard of *object oriented programming*, you might have heard about classes. I believe the idea behind the class concept, is best explained by an example.

Let say we want to progrmmatically represent a rectangle (the geometric shape). Our rectangle will have the following properties:

* X offset (X coordinate of upper left corner)
* Y offset (Y coordinate of upper left corner)
* Width
* Height

In C code you would normally create a `struct` type that represented the collection of properties like this:

```c
struct Rect {
    int x;
    int y;
    int width;
    int height;
};
```

If we want to create a `Rect` variable in C, we now do:

```c
struct Rect windowFrame;
windowFrame.x = 10;
windowFrame.y = 10;
windowFrame.width = 500;
windowFrame.height = 500;
```

A `struct` in C provides a great way of grouping properties that are related. In C++ we achieve the same with the `class` keyword:

```cpp
class Rect {
public:
    int x;
    int y;
    int width;
    int height; 
};
```

Note that apart from the word change from `struct` to `class`, the only difference is the `public` keyword. Do not mind about this know, we shall get back to it.

Now in C++ we have declared the class `Rect`, can we can use it like this:

```cpp
Rect winFrm;
winFrm.x = 10;
winFrm.y = 10;
winFrm.width = 500;
winFrm.height = 500;
```

Notice we just declare the type `Rect`, no need for the any extra keyword, like `struct` in C.

What we have in fact created now are an *instance* of our class *Rect*. An instance is also called an *object*.

### Adding functions to classes

Let's say we want a function to calculate the area of our rectangle. Simple in C:

```c
int calcArea(struct Rect rct)
{
    return rct.width * rct.height;
}
```

Now, the same can be done with a C++ class, instead of a *struct* - just by removing the `struct` keyword. However, the concept of *object oriented programming* teaches something else.

We should group functionality and data. That means our *Rect* class should itself know how to calculate its own area. Just like the `Rect` has `width`and `height` properties, it should have an `area` property.

We *could* define an extra variable in the class, like this:

```c
int area;
```

This would be error prone though, since we have to remember to update this everytime we change `width`or `height`. No, let us instead define `area` as a function that exists on `Rect`. The complete class definition will look like this:

```cpp
class Rect
{
public:
    int x, y;
    int width, height;

    int area()
    {
        return width * height;
    }
};
```

Now our *Rect* class consists of the 4 properties and a function called `area()`, that returns an `int`. A function that is defined on class like this, is called a *method*.

We can use the *method* like this:

```cpp
Rect winFrm;
winFrm.x = 10;
winFrm.y = 10;
winFrm.width = 500;
winFrm.height = 500;

int area = winFrm.area();
```

This is the idea of object oriented coding - where data and related functionality are grouped together.

### Access levels

As promised earlier let us talk briefly about the `public` keyword. C++ lets you protect variables and methods on your classes using 3 keyword: `public`, `protected` and `private`.

So far we only seen *public* in use, because it allows us to access properties from outside the class. However, we can use the other keyword to mark variables as inaccessable from outside the class, like this:

```cpp
class CreditCard
{
private:
    const char *cardNumber;

protected:
    const char *cardType;
    const char * cardholderName;
    int expirationMonth;
    int expirationYear;

public:
    const char *cardAlias;

    int getAmount();
};
```

In this example we created the class *CreditCard*, that defines a persons credit card with all the data normally present on a credit card.

Some data is sensitive and we don't want developers to access them without care. Therefore we can use access protection levels to block access to properties from code outside the class itself.

#### Private members

The variable `cardNumber` is marked as *private*. This means it is visible only from inside the *CreditCard* class itself. No outside code or class can reference it. Not even a subclass of *CreditCard* have access to it.

You should use *private* properties only when you actively want to block future access to variables or methods. Don't use it if you just can't see any reason not to. The paradigm should be to actively argue that future developers shall never access this property.

Unfortunately in C++ this is the default access level. If you do not mark your members with *public* or *protected*, they become *private* by default.

#### Protected members

All *protected* variables and methods are inaccessable from outside the class, just like private variables. However, subclasses can access *protected* variable and methods.

If you have a variable the should be shield from outside code, you should mark it as *protected*.

#### Public members

Public variable and methods are accessable both from outside the class and from subclasses. When a method is *public*, we can call it from outside the class, as we saw done with the `area()` method.

## Inheritance

Inheritance is classes standing on the shoulders of each other. If classes are one leg of object oriented programming, inheritance are the other.

Let us continue the rectangle example. I have heard about a  trend called 3D graphics! I really want my *Rect* shape to support this extra dimension. At the same time I already use my existing class `Rect` many places in my code, so I cannot modify it.

The first thought is to just reimplement the class as a 3D shape. Unfortunately my code is open source and I do not want to loose any *street cred* by not following the DRY (Don't Repeat Yourself) paradigm.

It is now inheritance comes to the rescue. We can use it to create a new class `Rect3D` that builds upon the existing `Rect` class, reusing the code and extending the functionality:

```cpp
class Rect3D : public Rect
{
public:
    int z;
    int depth;

    int volume()
    {
        return width * height * depth;
    }
}
```

See the colon at the first line? It defines that our `Rect3D` class inherits from `Rect`. We say that `Rect3D` is a *subclass* of `Rect`.

The magic here is the variables `x`, `y`, `width` and `height` now exists on `Rect3D` through inheritance. Same is true for the methods `area()`.

Inheritance takes all methods and variables (also called properties) at makes them present on subclasses.

The `public` keyword instructs that *public* members on the parent class are still *public* on the subclass.

Unfortunately in C++ the default inheritance access level is *private*. This means you almost always need to declare the inheritance as *public*.

Let's try our new 3D class:

```cpp
Rect3D cube;
cube.x = 10;
cube.y = 10;
cube.z = 10;

cube.width = 75;
cube.height = 75;
cube.depth = 75;

int area = cube.area(); // gives 5625
int volume = cube.volume(); // gives 421875
```

Now we have two classes, where one (Rect3D) inherits from the other (Rect). Our code is kept *DRY* and existing code that uses `Rect` is not affected by the existence of `Rect3D`.

### Overloading methods

Luckily for us, we denote area and volume different. This meant that the method `volume()` in `Rect3D` does not conflict with the exitsing method `area()`. We are not always that lucky.

Say we had added a method that calculated the surface area of the shape. In the two dimensional *Rect* the surface and *area* are the same, so a `surface()` method is trivial:

```cpp
int surface()
{
    return area();
}
```

Our method simply calls the existing `area()` method and returns its result. But now *Rect3D* inherits this behaviour - which is incorrect in three dimensions.

To get the suface area of a cube we must calculate the area of each side, and sum for all sides. We use *method overloading* to re-declare the same method on `Rect3D`:

```cpp
int surface()
{
    return width  * height * 2
         + width  * depth  * 2
         + height * depth  * 2;
}
```

Now both classes declare a method with the same name and arguments. The effect is `Rect3D`'s `surface()` method replaces the method on the parent class.

A complete exmaple of the code is:

```cpp
class Rect {
public:
    int width, height;

    int area()
    {
        return width*height;
    }

    int surface()
    {
        return area();
    }
};

class Rect3D : public Rect
{
public:
    int depth;

    int surface()
    {
        return width  * height * 2
             + width  * depth  * 2
             + height * depth  * 2; 
    }
};
```

### Multiple inheritance

In C++ your classes can actually inherit from more than one class. This is called multiple inheritance. Let us examplify this by breaking up our *Rect* into two classes: *Point* and *Size*:

```cpp
class Point
{
public:
    int x, y;
};

class Size
{
public:
    int width, height;

    int area()
    {
        return width * height;
    }
};
```

If we now combine `Point` and `Size`, we get all the properties needed to represent a *Rect*. Using multiple inheritance we can create a new `Rect` class that build upon both `Point` and `Size`:

```cpp
class Rect : public Point, public Size
{

};
```

Our new *Rect* class does not define anything on it own, it simple stand on the shoulders of both *Point* and *Size*.

#### Inbreeding

When using multiple inheritance you should be aware of what is called the *diamond problem*. This occurs when your class inherits from two classes with a common ancestor.

In our geometry example, we could introduce this diamond problem be letting both `Point` and `Size` inherit from a common parent class, say one called: `Shape`.

In C++ there are ways around this issue called *virtual inheritance*, it is an advanced topic though. In this article we will not go into detail about this - you should just know that the problem is solvable.

## Constructors

A *constructor* is a special method on a class that get called automatically when the class in created. Constructors often initialize default values of member variables.

When we develop for embedded systems, we cannot assume variable values are initialized to 0, upon creation. For this reason we want to explicitly set all variables of our `Rect` class to 0:

```cpp
class Rect
{
public:
    int x, y;
    int width, height;

    Rect()
    {
        x = y = 0;
        width = height = 0;
    }

    int area()
    {
        return width*height;
    }
};
```

Notice the special *contructor* method `Rect()` has no return type - not even `void`! Now we have created a constructor that sets all member variable to zero, so we ensure they are not random when we create an instance of `Rect`:

```cpp
Rect bound;
int size = bounds.area(); // gives 0
```

Our constructor is executed upon creation of the `bounds` variable.

When a constructor takes no arguments, as our, it is called the *default constructor*.

### Non-default Constructors

We can declare multiple constructors for our class in C++. Constructor can take parameters, just as function can.

Let us add another constructor to *Rect* that takes all the member variables as parameters:

```cpp
class Rect
{
public:
    int x, y, width, height;
    
    // The default constructor
    Rect()
    {
        x = y = width = height = 0;
    }

    // Our special contructor
    Rect(int _x, int _y, int _w, int _h)
    {
        x = _x;
        y = _y;
        width = _w;
        height = _h;
    }

    int area() { return width*height; }
};
```

Now we have a special constructor that initializes a Rect object with a provided set of values. Such contructors are very convenience, and makes our code less verbose:

```cpp
Rect bounds; // default constructor inits to 0 here
bounds.x = 10;
bounds.y = 10;
bounds.width = 75;
bounds.height = 75;

// now the same can be achived with a single line
Rect frame(10,10, 75, 75);
```

When you call a special constructor like `Rect(10,10,75,75)` the *default constructor* is *not* executed! In C++ only one constructor can be executed, they can not be chained.

### The rule of 3

I shall briefly touch the *Rule of Three* concept, though it is beyond the scope of this article.

When you assign objects in C++ its contents is automatically copied to the destination variable:

```cpp
Rect rct1(5,5,10,10); // special constructor
Rect rct2; // default constructor
rct2 = rct1; // assignment, rct1 is copied to rct2
```

All of *Rect* member variables are automatically copied by C++. This is mostly fine, but there are times when you need or want special behaviour. For example is we create a *buffer* class we might not want to copy memory back and forth.

```cpp
class Buffer
{
public:
    bool isOriginal;
    char *data;

    Buffer()
    {
        isOriginal = false;
        data = 0;
    }

    Buffer(char *ptr, int size)
    {
        isOriginal = true;
        data = malloc(size)
        memcpy(data, ptr, size);
    }
};
```

In this case, if we assign an instance of `Buffer` from one variable to another, all data (10,000 bytes) is copied and takes up memory. It would be better of two instances of *Buffer* could share the same data.

To achieve this, we must overwrite two implicit defined methods in C++. They are the *copy constructor* and the *assignment operator*.

#### The Copy Constructor

The copy constructor is a special constructor that takes an instance of an object and initializes itself as a copy. C++ calls the *copy constructor* when creating a new variable from an existing one. These are common examples:

```cpp
Rect frame(0,0,100,100); // special constructor
Rect frame2 = frame; // copy constructor
someFunction(frame); // copy constructor again
```

When we create a new instance by assigning an existing object the *copy constructor* is used. Further, is we have a function or method and takes a class type as parameter, the function is provided a copy of the object by the *copy contructor*.

To create your own copy constructor you define it like this:

```cpp
class Rect
{
public:
    // copy constructor
    Rect(const Rect &other)
    {
        x = other.x;
        y = other.y;
        width = other.width;
        height = other.height;
    }
};
```

We left out the other constructor, and members in this example. The *copy constructor* is constructor method that takes a `const` reference to another instance of its class.

Of the *rect* class we just copy all variables. This also the default behaviour of C++, if we had not defined any *copy constructor*. However, in the *Buffer* example, our *copy constructor* culd like this:

```cpp
class Buffer
{
public:
    //copy constructor
    Buffer(const Buffer &other)
    {
        isOriginal = false;
        data = other.data;
    }
};
```

Now the *copy contructor* does not copy the class contents. It just assigns the pointer to the data to the new instance. This means the two existing instances (the copy and the original), share the same data array.

#### The Assignment Operator

There is still a case where C++ will copy all the contents of *Buffer*. It is where the *implicit* or default *assignment operator* is used. And this occurs in when:

```cpp
Buffer buf1(existingData); // special constructor
Buffer buf2; // default constructor
buf2 = buf1; // assignment operator
```

Here we create a instance with some data `buf1`, and a zeroed instance `buf2`. If we want the same behaviour as with the *copy constructor*, we need to declare the *assignment operator* on *Buffer*:

```cpp
class Buffer
{
public:
    // assignment operator
    Buffer& operator=(const Buffer &rhs)
    {
        isOriginal = false;
        data = rhs.data;
        return *this;
    }
};
```

Just like the *copy constructor*, the assignment operator takes a `const` reference to the object that need to be assigned (copied). But it assignment must also return a reference of itself, as defined by `Buffer&`. This is also why we have to include the `return *this` statement. `this` is a pointer to the instance of the class - the object itself.

Any C pointer juggling champ, will recognize that we derererence the pointer by adding the asterisk (`*`) in front.

#### The Deconstructor

This is the last part of the *Rule of Three* in C++.

THe *deconstructor* is the inverse of the constructor - it is called when an object dies or rather is deallocated. Object gets deallocated when the go out of scope.

In our *Buffer* example we want the *deconstructor* to free any allocated memory - but only if the object is the original data owner:

```cpp
class Buffer
{
public:
    bool isOriginal;

    //the deconstructor
    ~Buffer()
    {
        if (isOriginal) {
            free(data);
        }
    }
};
```

The *deconstructor* is defined as the classname with a tilde (`~`) in front. A deconstructor takes no arguments.

Now you see why we declared the `isOriginal` variable earlier. We must not `free` memory we do not own. This means all the copies can dealloc with data still present. Only deallocing the original will flush the data content.

```eval_rst
.. note:: I am aware that deallocing the original before any of the copies will leaves dangling pointers to freed data. We have implement a quite crude data management system here, but it can easily be augmented to be a working reference counting implementation.
```

Now this is the rule of three. Defining the:

* *copy constructor*
* *assignment operator*
* *deconstructor*

When you create your own C++ classes, think about these three. Mostly you don't have to implement them, but in some cases you will.

## Namespaces

When developing your application you might choose class names that already existing in the system. say you create a class called *String*, changes are that this name is taken by the systems own *String class*. In deed this is the case in OpenMono SDK.

To avoid name collisions for common classes such as *Array*, *String*, *Buffer*, *File*, etc. C++ has a feature called *namespaces*.

A *namespace* is a grouping of names, inside a named container.  All OpenMono classes provided by the SDK is defined inside a *namespace* called `mono`. You can use double colens to reference classes inside namespaces:

```cpp
mono::String str1;
mono::io::Wifi wifi;
mono::ui::TextLabelView txtLbl;
```

Here we define instances (using the *default constructor*) that are declared inside the namespace `mono` and the sub-namespaces: `io` and `ui`.

### Declaring namespaces

So far we have seen only classes declared in global space. That is outside any namespace. Say, we want to group all our geometric classes in a namespace called `geo`.

Then *Rect* would be declared as such:

```cpp
namespace geo {
    class Rect
    {
    public:
        int x,y,width,height;

        // ...
    };
}
```

Now, any code inside the `namespace geo { ... }` curly braces can reference the class `Rect` by its name. However, any code outside the namespace must define the namespace as well as the class name: `geo::Rect`.

Namespaces can contains other namespaces. We can create a new namespace inside `geo` called `threeD`. Then we can rename `Rect3D` to `Rect` and declare it inside the `threeD` namespace:

```cpp
namespace geo {
    namespace threeD {
        class Rect : public geo::Rect
        {
            int z, depth;

            // ...
        };
    }
}
```

### The *using* directive

If you are outside a namespace (like `geo`) and often find yourself referencing `geo::Rect`, there is a short cut. C++ offers a `using` directive much like C# does.

The `using` directive imports a namespace into the current context:

```cpp
using namespace geo;

Rect frame;
```

Now you do not have to write `geo::Rect`, just `Rect` - since `geo` has become implicit.

If you look through OpenMono SDK's source code, you will often see these `using` statement at the beginning of header files:

```cpp
using namespace mono;
using namespace mono::ui;
using namespace mono::geo;
```

This reduces the verbosity of the code, by allowing referencing classes without namespace prefixes.

#### *Using* a single class

Another less invasive option is to import only a specific class into the current context - not a complete namespace. If you now you are only going to need the `geo::Rect` class and not any other class defined in `geo`, you can:

```cpp
using geo::Rect;

Rect frame;
```

THis imports only the *Rect* class. This allows you to keep your context clean.

```eval_rs
.. note:: On a side note, remember that importing namespaces has no effect on performance. C++ is a compiled language, and namespaces does not exist in binary. You can declare and import as many namespaces as you like - the compiled result is not affected on performance.
```

## References

C++ introduces an alternative to C pointers, called references. If you know C pointers, you are similiar with the `*` syntax. If you don't, just know that in C you can provide a copy of a variable or a pointer to the variable. (We saw that in the *Buffer* example earlier.)

In C you denote pointer types with an asterisk (`*`). C++ introduces references denotes by an ampersand (`&`), which are somewhat like pointers.

A reference in C++ is constant pointer to another object. This means a reference cannot be re-assigned. It is assigned upon creation, and cannot change later:

```cpp
Rect frame = Rect(0,0,25,25);
Rect& copy = frame;
Rect frm2;
copy = frm2; // AArgh, compiler error here!!
```

The `copy` variable is a reference to `frame` - always. In contrast to pointers in C, you do not have to take the address of an variable to assign the reference. C++ handles this behind the scenes.

### Reference in functions

A great place to utilze references in C++ is when defining parameters to functions or methods. et us declare a new method on `Rect` that check if a `Point` is inside the *rects* interior. This method can take a reference to such a point, no reason to copy data back and forth - just pass a reference:

```cpp
class Rect
{
public:
    // rect of decleration left out
    bool contains(const Point &pnt)
    {
        if (   pnt.x > x && pnt.x <= (x + width)
            && pnt.y > y && pnt.y <= (y +height))
            return true;
        else
            return false;
    }
}
```

Our method takes a reference to a Point class, as denoted by the ampersand (`&`). Also, we have declared the reference as `const`. This means we will not modify the `pnt` object.

If we left out the `const` keyword, we are allowed to make changes to `pnt`. By declaring it `const` we are restraining yourself from being able to modify `pnt`. This help the C++ compiler create more efficient code.

## Further reading

C++ is an admittedly an avanced and tough language. I still bang my head against the wall sometimes. More modern languages like Java and C# are easier to use. But in an embedded environment we run have the luxuary of a large runtime. So for now, we are left with C++.

There are still a ton of topics that I did not cover here. I'd like to encourage you to read about these more advanced topics:

* Static variables
* Static methods
* Operator overloads
* Constant methods
* Interfaces
* Virtual methods
* Polymorhpism