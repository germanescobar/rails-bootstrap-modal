# README

This example shows how to display a form inside a Bootstrap modal in Rails **using JS views**.

The key idea behind this solution is that you can create routes that, instead of rendering HTML or redirecting the user to another action, return some JS code that is executed on the client.

Let's see the code of the link that shows the modal:

```erb
<%= link_to "New Contact", new_contact_path, remote: true, class: "btn btn-primary" %>
```

It points to the `new_contact_path` route, but notice the `remote: true`. This tells Rails to call this route using AJAX.

The `new` action inside `ContactsController` is the following:

```ruby
class ContactsController < ApplicationController
  ...
  def new
    @contact = Contact.new
  end
  ...
end
```

The view `new.js.erb` (notice the JS extension) renders the form and displays the modal:

```erb
$('<%= j render "form" %>').modal();
```

**Note:** The `j` helper allows us to embed HTML code inside JS (it escapes the HTML removing new lines, quotes, and other characters that could break the JS).

The `_form.html.erb` partial contains the modal with the form:

```html
<div id="contact-modal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      ...
      <%= form_for @contact, remote: true do |f| %>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        ...
      </div>
      <% end %>
    </div>
  </div>
</div>
```

Notice the `remote: true` in the form helper method. Again, this instructs Rails to submit this form using AJAX.

The `create` action inside `ContactController` is the following:

```ruby
def create
  @contact = Contact.create(contact_params)
end
``

The view `create.js.erb` (again, this is a JS view), hides the modal and appends the row to the table:

```erb
<% if @contact.errors.blank? %>
  $('#contact-modal').modal('hide');
  $('table tbody').append('<%= j render "contact_row", contact: @contact %>');
<% else %>
  // TODO: show the errors in the UI
<% end %>
```