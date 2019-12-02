# BUILD A GROUP CHAT APP USING .NET CORE

Based on Gideon Onwuka work: [https://pusher.com/tutorials/group-chat-net](https://pusher.com/tutorials/group-chat-net)
    
In this article, we’ll build a group chat application in .NET Core MVC.  [Pusher](http://pusher.com/)  sits between our server and client. It simplifies adding realtime functionality to our group chat app.

Here is a preview of what you’ll be building:

![](https://images.contentful.com/1es3ne0caaid/u7v55YS5WKi4KeCeIGe6c/3707712bc7a0733359d1308a80beecf5/group-chat-net-demo.gif)

## Prerequisites

1.  Install  [Visual Studio Code](https://code.visualstudio.com/),
2.  Install the  [.NET Core SDK](https://www.microsoft.com/net/download/core).
3.  Install the [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) from the Visual Studio Code Marketplace

Verify your setup by typing the following in your command line:
```dotnet --version```

This should print out the visual studio code version you have installed.

## Setting up Pusher app

Next, let’s create an app in our  [Pusher](https://pusher.com/)  account for the group chat application.

1.  Sign up or login to your  [Pusher](https://pusher.com/signup)  account.
2.  Create a new pusher app.

![](https://images.contentful.com/1es3ne0caaid/6O54kBQseW8i2yqCCQkG8C/af765dfe786811291ae454ac79b4896f/group-chat-net-create-app.png)

3.  After filling the form above, click on  **Create my app**  button to create the app.
4.  The next page is a getting started page with code samples. You should click on  **App Keys**  tab to get your Pusher app details.

We’ll need these keys later, so keep them handy! Make sure you add your correct Pusher app details below.  `PUSHER_APP_ID`,  `PUSHER_APP_KEY`,  `PUSHER_APP_SECRET`,  `PUSHER_APP_CLUSTER`  are just a place holders, replace them with your actual Pusher app details and note it down:

```
app_id  = "PUSHER_APP_ID"
key     = "PUSHER_APP_KEY"
secret  = "PUSHER_APP_SECRET"
cluster = "PUSHER_APP_CLUSTER"

```

## Setting up our chat project

First, create a new directory on your system -  `GroupChat`. Then from your command line, CD(change directory) into the folder your just created.

- Go to C:\ and create the GroupChat folder

Then from your command line, run the following commands:

```csharp
cd C:\GroupChat
dotnet new mvc --auth Individual
```
This command creates a new ASP.NET Core MVC project with authentication in your current folder.

We have included authentication ([Identity](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/identity?tabs=netcore-cli%2Caspnetcore2x)) in this app because we want to uniquely identify each user so we can easily group them. ASP.NET Core  [Identity](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/identity?tabs=netcore-cli%2Caspnetcore2x)  makes it easy to add login features to .NET Core apps.

> 💡 ASP.NET Core Identity is a membership system which allows you to add login functionality to your application. Users can create an account and login with a user name and password or they can use an external login provider such as Facebook, Google, Microsoft Account, Twitter or others.

Now, open the  `GroupChat`  folder in Visual Studio Code editor.

> 💡 If your Visual Studio Code have been set to your system path, you can open the project by typing  **“code .”**  (without quotes) in your command prompt.

-   Select  **Yes**  to the  **Warn**  message "Required assets to build and debug are missing from 'GroupChat'. Add them?"
-   Select  **Restore**  to the  **Info**  message "There are unresolved dependencies".

Next, Press  **Debug**  (F5) to build and run the program. In your browser navigate to  [http://localhost:5000/](http://localhost:5000/api/values). You should see a default page.

## Adding our models

A model is an object that represents the data in your application. We’ll need several models for our application. Start by creating the models for our table structure. For this project, we’ll need to create three tables -  `Group`,  `UserGroup`  and  `Message`.

### Group model

In the Group table, we’ll need the following columns: ID (int) and GroupName (string) where the  `ID`  is the primary key. We’ll store all groups in this table.

Create a new file in the  `/Models`  folder called  `Group.cs`  and add the following code to it:

```
    using System;
    namespace GroupChat.Models
    {
        public class Group
        {
            public int ID { get; set; }
            public string GroupName { get; set; }
        }
    }
```

### UserGroup model

In the UserGroup table, we’ll need the following columns: ID (int), UserName (string) and GroupId (int). We’ll store the User ID and Group ID in this table.

Create a new file in the  `/Models`  folder called  `UserGroup.cs`  and add the following code to it:

```
    using System;

    namespace GroupChat.Models
    {
        public class UserGroup
        {
            public int ID { get; set; }
            public string UserName { get; set;  }
            public int GroupId { get; set;  }
        }
    }
```

### Message model

In the message table, we’ll need the following columns: ID (int) , AddedBy (string), message (string) and GroupId (int). Here, we’ll store all messages entered by all user.

Create a new file in the  `/Models`  folder called  `Message.cs`  and add the following code to it:

```
    using System;

    namespace GroupChat.Models
    {
        public class Message
        {
            public int ID { get; set; }
            public string AddedBy { get; set;  }
            public string message { get; set;  }
            public int GroupId { get; set;  }
        }
    }
```

## Creating the database context

The  _database context_  is the main class that coordinates  [Entity Framework](https://docs.microsoft.com/en-us/aspnet/mvc/overview/getting-started/getting-started-with-ef-using-mvc/creating-an-entity-framework-data-model-for-an-asp-net-mvc-application)  functionality for a given data model. We’ll derive from the  `Microsoft.EntityFrameworkCore.DbContext`  to create this class.

Create a new file called  `GroupChatContext.cs`  in the  `/Models`  folder:

```
    using Microsoft.EntityFrameworkCore;
    namespace GroupChat.Models
    {
        public class GroupChatContext : DbContext
        {
            public GroupChatContext(DbContextOptions<GroupChatContext> options)
                : base(options)
            {
            }

            public DbSet<Group> Groups { get; set; }
            public DbSet<Message> Message { get; set; }
            public DbSet<UserGroup> UserGroup { get; set; }
        }
    }
```

## Setting up our database and running migrations

Now that we have created our models, we can easily generate a migration file that will contain code to easily create and update our table schema.

### Registering the database context

First, let’s register the database context we have created earlier. We’ll register the database context with the  [dependency injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)  container. Services (such as the DB context) that are registered with the dependency injection container are available to the controllers. Also, we’ll use Sqlite for our database.

Update the contents of the  `/Startup.cs`  file with the following code:

```
    [...]
    public void ConfigureServices(IServiceCollection services)
    {
       [...]
        services.AddDbContext<GroupChatContext>(options =>
          options.UseSqlite(Configuration.GetConnectionString("DefaultConnection")));
       [...]
    }
    [...]
```

You can see the database context as a database connection and a set of tables, and the Dbset as a representation of the tables themselves. The database context allows us to link our model properties to our database with a connection string (in our case, we are using SQLite)

### Running migration

```
    $ dotnet ef migrations add GroupChat --context GroupChatContext
    $ dotnet ef database update --context GroupChatContext

```

The first command will create a migration script that will be used for managing our database tables. We’ve also added  `--context`  to the commands so as to specify the context we want to run. This is because there is another context for Identity which has been created automatically by the template.

> 💡 If you got an error while running the command, stop the debugging or the server.

## Implementing our chat interface

We’ll need an interface where a user can create a group, then add participating users to the group (only users added to a particular group can chat in that group).

We also need a route that will lead to the chat interface, like  [http://localhost:5000/chat](http://localhost:5000/chat). To do this we’ll need to create the chat controller and the chat view.

### Creating the chat controller

Create a new file called  `ChatController.cs`  in the Controllers folder then add the following code:

```
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Text.Encodings.Web;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Authentication;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Identity;
    using Microsoft.AspNetCore.Mvc;
    using GroupChat.Models;
    namespace GroupChat.Controllers
    {
        [Authorize]
        public class ChatController : Controller
        {
            private readonly UserManager<ApplicationUser> _userManager;
            private readonly GroupChatContext _GroupContext;
            public ChatController(
              UserManager<ApplicationUser> userManager,
              GroupChatContext context
              )
            {
                _userManager = userManager;
                _GroupContext = context;
            }
            public IActionResult Index()
            {
                return View();
            }
        }
    }
```

In the preceding code:

-   We have added  `Authorize`  to make sure that only logged in user can access our chat page.
-   We have also injected  `ApplicationUser`  and  `GroupChatContext`  into this class so we can have access to them in all our methods. The  `ApplicationUser`  is the context from Identity and we have created the  `GroupChatContext`  so we can have access to their respective tables in this class.

### Adding the chat view file

1.  Create a new folder in the View folder called  `chat`
2.  In the chat folder you just created, create a new file called  `index.cshtml`

Now, update the  `index.cshtml`  file with the code below:

```
    @{
        Layout = null;
    }
    <!doctype html>
    <html lang="en">
      <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">
        <title>DotNet Group Chat</title>
        <style type="text/css">
           .group {
              padding: 13px;
              border-radius: 12px;
              background: rgb(57, 125, 192);
              margin: 5px 0px;
              font-weight: bolder;
              color: black;
              cursor: pointer;
           }
          .chat_body {
            height: 520px;
            overflow: scroll;
          }

          .less_padding {
            padding: 2px;
          }
          .chat_message {
              padding: 13px;
              border-radius: 12px;
              width: 50%;
              background: #85C1E9;
              margin: 6px 4px;
          }
          .chat_main {
            background-color: #957bbe; 
            height: 520; 
            padding: 0px;
          }
          .group_main {
             background-color: #85C1E9;
          }
        </style>
      </head>
      <body>
        <h3 class="text-center">Welcome</h3>
            <div class="container" style="background-color: grey;">
                  <div class="row">
                    <div class="col-md-2 less_padding">
                      <div class="col group_main">
                           <div class="text-center"> Groups </div>
                           <div clsss="row" style="height: 500px;overflow: scroll;" id="groups">
                            <input type="hidden" value="" id="currentGroup">
                           <!-- List groups-->
                            </div>
                          <div class="text-center"> 
                              <button type="submit" class="btn btn-primary" data-toggle="modal" data-target="#CreateNewGroup">Add Group</button>
                          </div>
                      </div>
                    </div>
                    <div class="col-md-10 less_padding">
                      <div class="col-md-12 chat_main">
                           <div class="chat_body">
                                  <!-- <div class="chat_message float-right">Hello, </div> -->
                           </div>
                          <div class="row container" style="margin-left: 3px;">
                            <div class="col-md-9 col-sm-9 less_padding">
                                <textarea class="form-control" rows="1" id="Message"></textarea>   
                            </div>
                            <div class="col-md-3 col-sm-3 less_padding">
                                  <button type="submit" class="btn btn-primary" style=" position: absolute;" id="SendMessage">Send Message</button>
                            </div>
                          </div>
                      </div>
                   </div>
               </div>
            </div>
            <!-- Modal -->
            <div class="modal fade" id="CreateNewGroup" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                 <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Add New Group</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                 </div>
                <div class="modal-body">
                    <form id="CreateGroupForm">
                        <div class="form-group">
                            <label for="GroupName">Group Name</label>
                            <input type="text" class="form-control" name="GroupName" id="GroupName" aria-describedby="emailHelp" placeholder="Group Name">
                        </div>
                        <label for="User">Add Users <br></label> <br>
                        <div class="row">
                             <!-- List users here -->
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="CreateNewGroupButton">Create Group</button>
                </div>
              </div>
            </div>
          </div>
        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" integrity="sha384-a5N7Y/aK3qNeh15eJKGWxsqtnX/wWdSZSKp+81YjTmS15nvnvxKHuzaWwXHDli+4" crossorigin="anonymous"></script>
        <script src="https://js.pusher.com/4.1/pusher.min.js"></script>
        <script src="~/js/site.js" asp-append-version="true"></script>
      </body>
    </html>
```

Notice this at the top of the file:

```
    @{
        Layout = null;
    }

```

This is to tell the rendering engine not to include layouts partials(like header, footer) in this page. Also, we included the Pusher JavaScript library in this page. This will be discussed later.

You should now have a new route available -  `http://localhost:5000/chat`.  `/chat`  is the Controller’s name and since there is no other URL segment, this request will be mapped to the  `index`  method of the  `ChatController.cs`  method. Also in the index method, we have  `return View()`. This will render the view corresponding to the ChatController. It will look for the  `index.cshtml`  file in the  `/view/chat`  folder.

Heading to  [http://locahost:5000/chat](http://locahost:5000/chat)  will redirect you to a login page. Register an account and log in then visit the page again. You should have an interface like below:

![](https://images.contentful.com/1es3ne0caaid/4VvP2c76r6yUC4ggMiqEku/5ee8e586f9e01d9cf4551584a5af8fa5/group-chat-net-interface.png)

The left sidebar will be used to display all groups a user is subscribed to and the right side for all conversation messages in the groups. When a user clicks on a group, the corresponding message in that group will be displayed on the right. There is also a create group button. When a user clicks this button, a modal is displayed and the user can enter details of their new group. The modal will list all chat users. The group creator can select who they want to add to the group.

Now let’s get the group a user is subscribed to. After this, we’ll create a  `ViewModel`  to show the format of the output we want. Add the following code to the  `Index`  method in the  `ChatController.cs`  class:

```
    [...]
    var groups =  _GroupContext.UserGroup
                        .Where( gp => gp.UserName == _userManager.GetUserName(User) )
                        .Join( _GroupContext.Groups, ug => ug.GroupId, g =>g.ID, (ug,g) =>
                                new UserGroupViewModel{
                                    UserName = ug.UserName, 
                                    GroupId = g.ID,
                                    GroupName = g.GroupName})
                        .ToList();

    ViewData["UserGroups"] = groups;

    // get all users      
    ViewData["Users"] = _userManager.Users;
    [...]
```

Here we made use of LINQ to make a query to get all groups in the UserGroup table that the current user is subscribed to. The raw SQL query is as follows:

```
    SELECT "gp"."UserName", "g"."ID" AS "GroupId", "g"."GroupName"
                           FROM "UserGroup" AS "gp"
                           INNER JOIN "Groups" AS "g" ON "gp"."GroupId" = "g"."ID"
                           WHERE "gp"."UserName" = @__GetUserName_0
```

In the code above we used  `UserGroupViewModel`  to describe how the content of the query result should look, but we have not created the file. Create a new file -  `UserGroupViewModel.cs`  in the  `Models`  folder and add a view model:

```
    using System;
    using GroupChat.Models;
    namespace GroupChat.Models
    {
        public class UserGroupViewModel
        {
            public string UserName { get; set; }
            public int GroupId { get; set; }
            public string GroupName { get; set;  }
        }
    }
```

> 💡 A  `view model`  represents the data that you want to display on your view/page, or the input values you require for a request whether it be used for static text or for input values (like textboxes and dropdown lists) that can be added to the database. It is a model for the view.

### Display data to the chat view

Now that we have the user’s groups and all the users, let’s display them on the view. Add this to the header of  `Views/chat/index.cshtml`:

```
    @using Microsoft.AspNetCore.Identity
    @using GroupChat.Models

    @inject UserManager<ApplicationUser> UserManager
```

Update the html div that has an id=”groups” in  `Views/chat/index.cshtml`  as below:

```
    [...]
    <div clsss="row" style="height: 500px;overflow: scroll;" id="groups"> 
        @foreach (var group in (dynamic)ViewData["UserGroups"]) {
            <div class="group" data-group_id="@group.GroupId"> @group.GroupName </div> 
         }
    </div>
    [...]
```

Notice that we are storing  `data-group_id`  for every group rendered. This is the Group ID of the  `Group`  table which is unique so we can keep track of all groups easily.

Let us also display the users to the modal form. Add the following code below this comment  `<!--`  `List users here`  `-->`  in  `Views/chat/index.cshtml`:

```
    [...]
    <!-- List users here -->
    @foreach (var user in (dynamic)ViewData["Users"]) {
      <div class="col-4"> 
        <div class="form-check">
           <input type="checkbox" value="@user.UserName" name="UserName[]">
           <label class="form-check-label" for="Users">@user.UserName</label>
        </div>
      </div> 
    }
    [...]
```

## Adding groups

Before a user can start chatting with their friends, they need to create a group and add users to it. Now, let us add a view model that will define the structure of our form input when creating a new group. Create a new file called  `NewGroupViewModel.cs`  in the  `Models`  folder then add the following code to it:

```
    using System;
    using System.Collections.Generic;
    namespace GroupChat.Models
    {
        public class NewGroupViewModel
        {
            public string GroupName { get; set; }
            public List<string> UserNames { get; set; }
        }
    }
```

Next, create a new file called  `GroupController.cs`  in the Controllers folder. Then add the following code to  `GroupController.cs`:

```
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using GroupChat.Models;
    using System.Diagnostics;
    using Microsoft.AspNetCore.Identity;
    using Microsoft.AspNetCore.Authorization;
    namespace GroupChat.Controllers
    {
        [Route("api/[controller]")]
        [Authorize]
        public class GroupController : Controller
        {
            private readonly GroupChatContext _context;
            private readonly UserManager<ApplicationUser> _userManager;

            public GroupController(GroupChatContext context, UserManager<ApplicationUser> userManager)
            {
                _context = context;
                _userManager = userManager;
            }

            [HttpGet]
            public IEnumerable<UserGroupViewModel> GetAll()
            {

                var groups = _context.UserGroup
                              .Where(gp => gp.UserName == _userManager.GetUserName(User))
                              .Join(_context.Groups, ug => ug.GroupId, g =>g.ID, (ug,g) =>
                                            new UserGroupViewModel(){
                                                UserName = ug.UserName, 
                                                GroupId = g.ID,
                                                GroupName = g.GroupName})
                               .ToList();

                return groups;
            }

            [HttpPost]
            public IActionResult Create([FromBody] NewGroupViewModel group)
            {
                if (group == null || group.GroupName == "")
                {
                    return new ObjectResult(
                        new { status = "error", message = "incomplete request" }
                    );
                }
                if( (_context.Groups.Any(gp => gp.GroupName == group.GroupName)) == true ){
                    return new ObjectResult(
                        new { status = "error", message = "group name already exist" }
                    );
                }

                Group newGroup = new Group{ GroupName = group.GroupName };
                // Insert this new group to the database...
                _context.Groups.Add(newGroup);
                _context.SaveChanges();
                //Insert into the user group table, group_id and user_id in the user_groups table...
                foreach( string UserName in group.UserNames)
                {
                    _context.UserGroup.Add( 
                        new UserGroup{ UserName = UserName, GroupId = newGroup.ID } 
                    );
                    _context.SaveChanges();
                }
                return new ObjectResult(new { status = "success", data = newGroup });
            }
        }
    }
```

In the preceding code:

1.  The constructor uses  [Dependency Injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)  to inject the database context (`GroupChatContext`  and  `ApplicationUser`) into the controller. We have injected  `GroupChatContext`  and  `ApplicationUser`  context into the class so we can have access to the contexts.
2.  The  `GetAll`  method is a Get method request that will be used to get all groups a particular user is subscribed to.
3.  The  `Create`  method is a POST method request that will be used to create a new group.
4.  Using  `_context.Groups.Add(newGroup);`  `_context.SaveChanges();`, we added a new group to the database.
5.  Finally, with  `return`  `new`  `ObjectResult`(`new`  `{ status = "`success`", data = newGroup });`, we returned a JSON that indicates the request was successful.

Create a group by making an AJAX request to /api/group using a POST method. Add the following JavaScript code to  `/wwwroot/js/site.js`:

```
    $("#CreateNewGroupButton").click(function(){
        let UserNames = $("input[name='UserName[]']:checked")
            .map(function() {
                return $(this).val();
            }).get();

        let data = {
            GroupName: $("#GroupName").val(),
            UserNames: UserNames
        };

        $.ajax({
            type: "POST",
            url: "/api/group",
            data: JSON.stringify(data),
            success: (data) => {
                $('#CreateNewGroup').modal('hide');
            },
            dataType: 'json',
            contentType:'application/json'
        });

    });
```

## Displaying messages for an active group

When a user clicks on a particular group, we’ll fetch all messages in that group and display them on the page. To achieve this we’ll make use of JQuery and Ajax to make a request to an endpoint which we’ll expose later, by passing the group_id along with the request and then display the resulting data on the page.

### Create an endpoint for displaying messages for a particular group

Create a new file in the Controllers folder called  `MessageController.cs`  Then add the following code to  `MessageController.cs`  file:

```
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using GroupChat.Models;
    using Microsoft.AspNetCore.Identity;

    namespace GroupChat.Controllers
    {
        [Route("api/[controller]")]
        public class MessageController : Controller
        {
            private readonly GroupChatContext _context;
            private readonly UserManager<ApplicationUser> _userManager;
            public MessageController(GroupChatContext context, UserManager<ApplicationUser> userManager)
            {
                _context = context;
                _userManager = userManager;
            }

            [HttpGet("{group_id}")]
            public IEnumerable<Message> GetById(int group_id)
            {
                return _context.Message.Where(gb => gb.GroupId == group_id);
            }
        }
    }
```

In the code above,  `[Route("api/[controller]")]`  added at the top of the file will create a base route -  `/api`.

Also we added  `[HttpGet("{group_id}")]`  to  `GetById`  method so we have a route -  `/api/message/{group_id}`. The route -  `/api/message/{group_id}`  will return all messages for a particular group.

### Adding Ajax Request to Get the Messages and Display It

When a user clicks on a group, we’ll make a request to get all messages in that group. Add the following code to  `wwwroot/js/site.js`:

```
    // When a user clicks on a group, Load messages for that particular group.
    $("#groups").on("click", ".group", function(){
        let group_id = $(this).attr("data-group_id");

        $('.group').css({"border-style": "none", cursor:"pointer"});
        $(this).css({"border-style": "inset", cursor:"default"});

        $("#currentGroup").val(group_id); // update the current group_id to html file...
        currentGroupId =  group_id;

        // get all messages for the group and populate it...
        $.get( "/api/message/"+group_id, function( data ) {
            let message = "";

        data.forEach(function(data) {
            let position = (data.addedBy == $("#UserName").val()) ? " float-right" : "";

            message += `<div class="row chat_message` +position+ `">
                             <b>` +data.addedBy+ `: </b>` +data.message+ 
                       `</div>`;
        });

            $(".chat_body").html(message);
        });

    });
```

### Adding a view model

This view will help us define the nature of the form inputs we’ll use to make requests when we are adding a new message. Create a new file in the  `Models`  folder called  `MessageViewModel.cs`:

```
    using System;

    namespace GroupChat.Models
    {
        public class MessageViewModel
        {
            public int ID { get; set; }
            public string AddedBy { get; set;  }
            public string message { get; set;  }
            public int GroupId { get; set;  }
            public string SocketId { get; set;  }
        }
    }
```

We’ll discuss what we’ll use the  `SocketId`  for later in the article.

### Add method for adding message

Here, we’ll add a new method for adding messages to the database. Update  `MessageController.cs`  with the following code:

```
    [...]
    [HttpPost]
    public IActionResult Create([FromBody] MessageViewModel message)
    {
        Message new_message = new Message { AddedBy = _userManager.GetUserName(User), message = message.message, GroupId = message.GroupId };

        _context.Message.Add(new_message);
        _context.SaveChanges();

        return new ObjectResult(new { status = "success", data = new_message });
    }
    [...]
```

We can now send messages and store them in our database. However, other users do not get the messages in realtime. This is where Pusher comes in.

### Add new message via Ajax

When a user clicks on the send message button, we’ll make an AJAX call to the method we added above with the message payload so it gets saved in the database.

Add the following code to  `wwwroot/js/site.js`:

```
    $("#SendMessage").click(function() {
        $.ajax({
            type: "POST",
            url: "/api/message",
            data: JSON.stringify({
                AddedBy: $("#UserName").val(),
                GroupId: $("#currentGroup").val(),
                message: $("#Message").val(),
                socketId: pusher.connection.socket_id
            }),
            success: (data) => {
                $(".chat_body").append(`<div class="row chat_message float-right"><b>` 
                        +data.data.addedBy+ `: </b>` +$("#Message").val()+ `</div>`
                );

                $("#Message").val('');
            },
            dataType: 'json',
            contentType: 'application/json'
        });
    });
```

## Making our messaging realtime

Users can now send messages and create groups, and details are saved in the database. However, other users cannot see the messages or groups in realtime.

We will make use of  [Private channel](https://pusher.com/docs/client_api_guide/client_private_channels)  in Pusher which will restrict unauthenticated users from subscribing to channels they don’t have access to.

Basically, we will subscribe to a channel -  `group_channel`  and trigger an event -  `new_group`  when a new group is created, so when an event -  `new_group`  is triggered, we update the group tab for all users (we can use  [Public channel](https://pusher.com/docs/client_api_guide/client_public_channels)  for this).

We will also subscribe to other channels for messaging -  `private-1`,  `private-2`  etc but this will be a private channel because users who are not not subscribe to a particular group should not subscribe to it.

### Add Pusher .NET package

From your command line, make sure you are in the root folder of your project then type:

```
    $ dotnet add package PusherServer

```

### Adding authentication for private channel

When a user wants to subscribe to a private channel, Pusher will authenticate the user to make sure they have the right to subscribe to it by making a request to our authentication logic.

We will create a route -  `pusher/auth`  which Pusher will use for authentication.

Lets create an endpoint that Pusher will make a request to when it wants to authenticate a user. Create the route by adding the following code to  `Startup.cs`:

```
    app.UseMvc(routes =>
    {
       [...]
       routes.MapRoute(
            name: "pusher_auth",
            template: "pusher/auth",
            defaults: new { controller = "Auth", action = "ChannelAuth" });
      [...]
    });
```

Next, create a new file called  `AuthController.cs`  in the  `Controller`  folder and add the following code to it:

```
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using GChat.Models;
    using Microsoft.AspNetCore.Identity;
    using PusherServer;
    namespace GroupChat.Controllers
    {
        public class AuthController : Controller
        {
            private readonly GroupChatContext _context;
            private readonly UserManager<ApplicationUser> _userManager;

            public AuthController( GroupChatContext context, UserManager<ApplicationUser> userManager){
                 _context = context;
                 _userManager = userManager;
            }

            [HttpPost]
            public IActionResult ChannelAuth(string channel_name, string socket_id)
            {
                int group_id;
                if(!User.Identity.IsAuthenticated) {
                    return new ContentResult { Content = "Access forbidden", ContentType = "application/json" };
                }

                try
                {
                     group_id = Int32.Parse(channel_name.Replace("private-", ""));
                }
                catch (FormatException e)
                {
                    return Json( new  { Content = e.Message } );
                }

                var IsInChannel = _context.UserGroup
                                          .Where(gb => gb.GroupId == group_id 
                                                && gb.UserName == _userManager.GetUserName(User))
                                          .Count();

                if( IsInChannel > 0){
                    var options = new PusherOptions
                        {
                            Cluster = "PUSHER_APP_CLUSTER",
                            Encrypted = true
                        };
                    var pusher = new Pusher(
                        "PUSHER_APP_ID",
                        "PUSHER_APP_KEY",
                        "PUSHER_APP_SECRT",
                        options
                    );

                    var auth = pusher.Authenticate(channel_name, socket_id).ToJson();
                    return new ContentResult { Content = auth, ContentType = "application/json" };
                }
               return new ContentResult { Content = "Access forbidden", ContentType = "application/json" };
            }
        }
    }
```

Pusher will send along the Channel name and Socket Id of the user it wants to authenticate, here we extracted the group Id from the channel name. Then we query our database to check if that user is in that group. To make a private channel in Pusher, you just need to add  `Private-`  to the channel name you intend to use. In our case, we are using  `private-1`,  `private-2`  etc as the channel name.

### Triggering an Event When a Group Is Created

We’ll trigger an event to Pusher when a new group is created so others will see the newly created group.

Add the following code to the  `Create`  method in  `GroupController.cs`  before  `return new ObjectResult(new { status = success, data = newGroup });`  statement:

```
    var options = new PusherOptions
    {
        Cluster = "PUSHER_APP_CLUSTER",
        Encrypted = true
    };
    var pusher = new Pusher(
        "PUSHER_APP_ID",
        "PUSHER_APP_KEY",
        "PUSHER_APP_SECRET",
    options);
    var result = await pusher.TriggerAsync(
        "group_chat", //channel name
        "new_group", // event name
    new { newGroup } );
```

Make sure you use your own Pusher app details above.

Also, add this to the top of the file:

```
using PusherServer;

```

### Triggering an event when a new message is received

To trigger an event when a new message is added, add the following code to  `MessageController.cs`:

```
    var options = new PusherOptions
    {
        Cluster = "PUSHER_APP_CLUSTER",
        Encrypted = true
    };
    var pusher = new Pusher(
        "PUSHER_APP_ID",
        "PUSHER_APP_KEY",
        "PUSHER_APP_SECRET",
        options
    );
    var result = await pusher.TriggerAsync(
        "private-" + message.GroupId,
        "new_message",
    new { new_message },
    new TriggerOptions() { SocketId = message.SocketId });      
```

Make sure you use your own Pusher app details above.

We have added  `new TriggerOptions() { SocketId = message.SocketId }`, so as not to broadcast to the user that triggered the event.

Also, add this to the top of  `GroupController.cs`:

```
    using PusherServer;

```

### Display the new group when a user creates a group

When a new group is created, we will reload the groups for every user. Add the following function to  `wwwroot/js/site.js`:

```
    function reloadGroup(){
        $.get("/api/group", function( data ) {
            let groups = "";

           data.forEach(function(group){
               groups += `<div class="group" data-group_id="` 
                               +group.groupId+ `">` +group.groupName+  
                          `</div>`;
           });

           $("#groups").html(groups);
        });
    }
```

### Listen for new group

When a new group is created, we will call the  `reloadGroup()`  function. To listen for events, we need to initialize Pusher’s Javascript library. Add the following code to  `/wwwroot/js/site.js`:

```
    let currentGroupId = null;

    var pusher = new Pusher('PUSHER_APP_KEY', {
                 cluster: 'PUSHER_APP_CLUSTER',
                 encrypted: true
    });

    var channel = pusher.subscribe('group_chat');
    channel.bind('new_group', function(data) {
       reloadGroup();
    });
```

Make sure to add this to the top part of the code because some other code in the file will be using it.

In the preceding code:

1.  We initiated the Pusher JavaScript library using our Pusher key.
2.  Then we suscribed to a channel -  `group_chat`.
3.  Then we bound that channel to an event -  `new_group`. So when a new group is created, we call the function  `reloadGroup()`.

### Listen for new message

When a user sends a message, we need to show it to other users in the group. To do this, we will subscribe to a channel and bind that channel to an event. Add this to the  `$("#groups").on("click", ".group", function()…`  event in  `/wwwroot/js/site.js`:

```
    if( !pusher.channel('private-'+group_id) ){ // check if the user have subscribed to the channel before.
        let group_channel = pusher.subscribe('private-'+group_id);

        group_channel.bind('new_message', function(data) { 

          if (currentGroupId == data.new_message.GroupId) {
              $(".chat_body").append(`<div class="row chat_message"><b>` 
                  +data.new_message.AddedBy+ `: </b>` +data.new_message.message+ ` </div>`
              );
          ']}

        });  
    }           
```

So it should now look like this:

```
    // When a user clicks on a group, Load messages for that particular group.
    $("#groups").on("click", ".group", function(){
        let group_id = $(this).attr("data-group_id");

        $('.group').css({"border-style": "none", cursor:"pointer"});
        $(this).css({"border-style": "inset", cursor:"default"});

        $("#currentGroup").val(group_id); // update the current group_id to a html form...
        currentGroupId =  group_id;

        // get all messages for the group and populate it...
        $.get( "/api/message/"+group_id, function( data ) {
            let message = "";

            data.forEach(function(data){
                    let position = ( data.addedBy == $("#UserName").val() ) ? " float-right" : "";
                    message += `<div class="row chat_message` + position +`"><b>`+ data.addedBy +`: </b>`+ data.message +` </div>`;
            });

            $(".chat_body").html(message);
        });
        if( !pusher.channel('private-'+group_id) ){ // check the user have subscribed to the channel before.
            let group_channel = pusher.subscribe('private-'+group_id);

            group_channel.bind('new_message', function(data) { 
                 if( currentGroupId == data.new_message.GroupId){

                      $(".chat_body").append(`<div class="row chat_message"><b>`+ data.new_message.AddedBy +`: </b>`+ data.new_message.message +` </div>`);
                 }
              });  
        }
    });
```
