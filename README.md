# Mono Docs

This is the source for the site that holds documentation for development
on [Mono](http://openmono.com).

The [site that displays the documentation](http://developer.kaleidoscope.one)
is read-only.

To contribute to the documentation itself, submit pull requests against
[the GitHub repository](https://github.com/getopenmono/monodocs).

## Initial setup

First install [Otto](https://ottoproject.io/).

Then clone [the GitHub repository](https://github.com/getopenmono/monodocs)
and run `otto`.

The files that otto generates in `.otto/compiled/` need to be tweaked, so
modify them by looking at the `templates/`, like
```
diff -uw .otto/compiled/app/dev/Vagrantfile templates/app/dev/Vagrantfile
```
Do not just copy.

## How to run the site locally

Start a virtual machine by `otto dev`.

Log into it by `otto dev shh`.

Then start the site inside the virtual machine by
`bundle install` and then `bundle exec passenger start`.

Now the site should be running on `http://$(otto dev address):3000/`

## How to deploy

Make sure to modify the otto-generated files by the templates.

```
otto infra
otto build
otto deploy
```

## Testing, testing, one, two...

{{{{{{ blue-modern
    alice->bob: Test
    bob->alice: Test response
}}}}}}

$$\Omega(n^2 \times \text{log}(n))$$

And now, the end.
My Friend.

