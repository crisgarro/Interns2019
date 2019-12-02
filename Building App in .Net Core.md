---


---

<h1 id="build-a-group-chat-app-using-.net-core">BUILD A GROUP CHAT APP USING .NET CORE</h1>
<p>Based on Gideon Onwuka work: <a href="https://pusher.com/tutorials/group-chat-net">https://pusher.com/tutorials/group-chat-net</a></p>
<p>In this article, we’ll build a group chat application in .NET Core MVC.  <a href="http://pusher.com/">Pusher</a>  sits between our server and client. It simplifies adding realtime functionality to our group chat app.</p>
<p>Here is a preview of what you’ll be building:</p>
<p><img src="https://images.contentful.com/1es3ne0caaid/u7v55YS5WKi4KeCeIGe6c/3707712bc7a0733359d1308a80beecf5/group-chat-net-demo.gif" alt=""></p>
<h2 id="prerequisites">Prerequisites</h2>
<ol>
<li>Install  <a href="https://code.visualstudio.com/">Visual Studio Code</a>,</li>
<li>Install the  <a href="https://www.microsoft.com/net/download/core">.NET Core SDK</a>.</li>
<li>Install the <a href="https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp">C# extension</a> from the Visual Studio Code Marketplace</li>
</ol>
<p>Verify your setup by typing the following in your command line:<br>
<code>dotnet --version</code></p>
<p>This should print out the visual studio code version you have installed.</p>
<h2 id="setting-up-pusher-app">Setting up Pusher app</h2>
<p>Next, let’s create an app in our  <a href="https://pusher.com/">Pusher</a>  account for the group chat application.</p>
<ol>
<li>Sign up or login to your  <a href="https://pusher.com/signup">Pusher</a>  account.</li>
<li>Create a new pusher app.</li>
</ol>
<p><img src="https://images.contentful.com/1es3ne0caaid/6O54kBQseW8i2yqCCQkG8C/af765dfe786811291ae454ac79b4896f/group-chat-net-create-app.png" alt=""></p>
<ol start="3">
<li>After filling the form above, click on  <strong>Create my app</strong>  button to create the app.</li>
<li>The next page is a getting started page with code samples. You should click on  <strong>App Keys</strong>  tab to get your Pusher app details.</li>
</ol>
<p>We’ll need these keys later, so keep them handy! Make sure you add your correct Pusher app details below.  <code>PUSHER_APP_ID</code>,  <code>PUSHER_APP_KEY</code>,  <code>PUSHER_APP_SECRET</code>,  <code>PUSHER_APP_CLUSTER</code>  are just a place holders, replace them with your actual Pusher app details and note it down:</p>
<pre><code>app_id  = "PUSHER_APP_ID"
key     = "PUSHER_APP_KEY"
secret  = "PUSHER_APP_SECRET"
cluster = "PUSHER_APP_CLUSTER"

</code></pre>
<h2 id="setting-up-our-chat-project">Setting up our chat project</h2>
<p>First, create a new directory on your system -  <code>GroupChat</code>. Then from your command line, CD(change directory) into the folder your just created.</p>
<ul>
<li>Go to C:\ and create the GroupChat folder</li>
</ul>
<p>Then from your command line, run the following commands:</p>
<pre class=" language-csharp"><code class="prism  language-csharp">cd C<span class="token punctuation">:</span>\GroupChat
dotnet <span class="token keyword">new</span> <span class="token class-name">mvc</span> <span class="token operator">--</span>auth Individual
</code></pre>
<p>This command creates a new <a href="http://ASP.NET">ASP.NET</a> Core MVC project with authentication in your current folder.</p>
<p>We have included authentication (<a href="https://docs.microsoft.com/en-us/aspnet/core/security/authentication/identity?tabs=netcore-cli%2Caspnetcore2x">Identity</a>) in this app because we want to uniquely identify each user so we can easily group them. <a href="http://ASP.NET">ASP.NET</a> Core  <a href="https://docs.microsoft.com/en-us/aspnet/core/security/authentication/identity?tabs=netcore-cli%2Caspnetcore2x">Identity</a>  makes it easy to add login features to .NET Core apps.</p>
<blockquote>
<p>💡 <a href="http://ASP.NET">ASP.NET</a> Core Identity is a membership system which allows you to add login functionality to your application. Users can create an account and login with a user name and password or they can use an external login provider such as Facebook, Google, Microsoft Account, Twitter or others.</p>
</blockquote>
<p>Now, open the  <code>GroupChat</code>  folder in Visual Studio Code editor.</p>
<blockquote>
<p>💡 If your Visual Studio Code have been set to your system path, you can open the project by typing  <strong>“code .”</strong>  (without quotes) in your command prompt.</p>
</blockquote>
<ul>
<li>Select  <strong>Yes</strong>  to the  <strong>Warn</strong>  message “Required assets to build and debug are missing from ‘GroupChat’. Add them?”</li>
<li>Select  <strong>Restore</strong>  to the  <strong>Info</strong>  message “There are unresolved dependencies”.</li>
</ul>
<p>Next, Press  <strong>Debug</strong>  (F5) to build and run the program. In your browser navigate to  <a href="http://localhost:5000/api/values">http://localhost:5000/</a>. You should see a default page.</p>
<h2 id="adding-our-models">Adding our models</h2>
<p>A model is an object that represents the data in your application. We’ll need several models for our application. Start by creating the models for our table structure. For this project, we’ll need to create three tables -  <code>Group</code>,  <code>UserGroup</code>  and  <code>Message</code>.</p>
<h3 id="group-model">Group model</h3>
<p>In the Group table, we’ll need the following columns: ID (int) and GroupName (string) where the  <code>ID</code>  is the primary key. We’ll store all groups in this table.</p>
<p>Create a new file in the  <code>/Models</code>  folder called  <code>Group.cs</code>  and add the following code to it:</p>
<pre><code>    using System;
    namespace GroupChat.Models
    {
        public class Group
        {
            public int ID { get; set; }
            public string GroupName { get; set; }
        }
    }
</code></pre>
<h3 id="usergroup-model">UserGroup model</h3>
<p>In the UserGroup table, we’ll need the following columns: ID (int), UserName (string) and GroupId (int). We’ll store the User ID and Group ID in this table.</p>
<p>Create a new file in the  <code>/Models</code>  folder called  <code>UserGroup.cs</code>  and add the following code to it:</p>
<pre><code>    using System;

    namespace GroupChat.Models
    {
        public class UserGroup
        {
            public int ID { get; set; }
            public string UserName { get; set;  }
            public int GroupId { get; set;  }
        }
    }
</code></pre>
<h3 id="message-model">Message model</h3>
<p>In the message table, we’ll need the following columns: ID (int) , AddedBy (string), message (string) and GroupId (int). Here, we’ll store all messages entered by all user.</p>
<p>Create a new file in the  <code>/Models</code>  folder called  <code>Message.cs</code>  and add the following code to it:</p>
<pre><code>    using System;

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
</code></pre>
<h2 id="creating-the-database-context">Creating the database context</h2>
<p>The  <em>database context</em>  is the main class that coordinates  <a href="https://docs.microsoft.com/en-us/aspnet/mvc/overview/getting-started/getting-started-with-ef-using-mvc/creating-an-entity-framework-data-model-for-an-asp-net-mvc-application">Entity Framework</a>  functionality for a given data model. We’ll derive from the  <code>Microsoft.EntityFrameworkCore.DbContext</code>  to create this class.</p>
<p>Create a new file called  <code>GroupChatContext.cs</code>  in the  <code>/Models</code>  folder:</p>
<pre><code>    using Microsoft.EntityFrameworkCore;
    namespace GroupChat.Models
    {
        public class GroupChatContext : DbContext
        {
            public GroupChatContext(DbContextOptions&lt;GroupChatContext&gt; options)
                : base(options)
            {
            }

            public DbSet&lt;Group&gt; Groups { get; set; }
            public DbSet&lt;Message&gt; Message { get; set; }
            public DbSet&lt;UserGroup&gt; UserGroup { get; set; }
        }
    }
</code></pre>
<h2 id="setting-up-our-database-and-running-migrations">Setting up our database and running migrations</h2>
<p>Now that we have created our models, we can easily generate a migration file that will contain code to easily create and update our table schema.</p>
<h3 id="registering-the-database-context">Registering the database context</h3>
<p>First, let’s register the database context we have created earlier. We’ll register the database context with the  <a href="https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection">dependency injection</a>  container. Services (such as the DB context) that are registered with the dependency injection container are available to the controllers. Also, we’ll use Sqlite for our database.</p>
<p>Update the contents of the  <code>/Startup.cs</code>  file with the following code:</p>
<pre><code>    [...]
    public void ConfigureServices(IServiceCollection services)
    {
       [...]
        services.AddDbContext&lt;GroupChatContext&gt;(options =&gt;
          options.UseSqlite(Configuration.GetConnectionString("DefaultConnection")));
       [...]
    }
    [...]
</code></pre>
<p>You can see the database context as a database connection and a set of tables, and the Dbset as a representation of the tables themselves. The database context allows us to link our model properties to our database with a connection string (in our case, we are using SQLite)</p>
<h3 id="running-migration">Running migration</h3>
<pre><code>    $ dotnet ef migrations add GroupChat --context GroupChatContext
    $ dotnet ef database update --context GroupChatContext

</code></pre>
<p>The first command will create a migration script that will be used for managing our database tables. We’ve also added  <code>--context</code>  to the commands so as to specify the context we want to run. This is because there is another context for Identity which has been created automatically by the template.</p>
<blockquote>
<p>💡 If you got an error while running the command, stop the debugging or the server.</p>
</blockquote>
<h2 id="implementing-our-chat-interface">Implementing our chat interface</h2>
<p>We’ll need an interface where a user can create a group, then add participating users to the group (only users added to a particular group can chat in that group).</p>
<p>We also need a route that will lead to the chat interface, like  <a href="http://localhost:5000/chat">http://localhost:5000/chat</a>. To do this we’ll need to create the chat controller and the chat view.</p>
<h3 id="creating-the-chat-controller">Creating the chat controller</h3>
<p>Create a new file called  <code>ChatController.cs</code>  in the Controllers folder then add the following code:</p>
<pre><code>    using System;
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
            private readonly UserManager&lt;ApplicationUser&gt; _userManager;
            private readonly GroupChatContext _GroupContext;
            public ChatController(
              UserManager&lt;ApplicationUser&gt; userManager,
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
</code></pre>
<p>In the preceding code:</p>
<ul>
<li>We have added  <code>Authorize</code>  to make sure that only logged in user can access our chat page.</li>
<li>We have also injected  <code>ApplicationUser</code>  and  <code>GroupChatContext</code>  into this class so we can have access to them in all our methods. The  <code>ApplicationUser</code>  is the context from Identity and we have created the  <code>GroupChatContext</code>  so we can have access to their respective tables in this class.</li>
</ul>
<h3 id="adding-the-chat-view-file">Adding the chat view file</h3>
<ol>
<li>Create a new folder in the View folder called  <code>chat</code></li>
<li>In the chat folder you just created, create a new file called  <code>index.cshtml</code></li>
</ol>
<p>Now, update the  <code>index.cshtml</code>  file with the code below:</p>
<pre><code>    @{
        Layout = null;
    }
    &lt;!doctype html&gt;
    &lt;html lang="en"&gt;
      &lt;head&gt;
        &lt;!-- Required meta tags --&gt;
        &lt;meta charset="utf-8"&gt;
        &lt;meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"&gt;
        &lt;!-- Bootstrap CSS --&gt;
        &lt;link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous"&gt;
        &lt;title&gt;DotNet Group Chat&lt;/title&gt;
        &lt;style type="text/css"&gt;
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
        &lt;/style&gt;
      &lt;/head&gt;
      &lt;body&gt;
        &lt;h3 class="text-center"&gt;Welcome&lt;/h3&gt;
            &lt;div class="container" style="background-color: grey;"&gt;
                  &lt;div class="row"&gt;
                    &lt;div class="col-md-2 less_padding"&gt;
                      &lt;div class="col group_main"&gt;
                           &lt;div class="text-center"&gt; Groups &lt;/div&gt;
                           &lt;div clsss="row" style="height: 500px;overflow: scroll;" id="groups"&gt;
                            &lt;input type="hidden" value="" id="currentGroup"&gt;
                           &lt;!-- List groups--&gt;
                            &lt;/div&gt;
                          &lt;div class="text-center"&gt; 
                              &lt;button type="submit" class="btn btn-primary" data-toggle="modal" data-target="#CreateNewGroup"&gt;Add Group&lt;/button&gt;
                          &lt;/div&gt;
                      &lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class="col-md-10 less_padding"&gt;
                      &lt;div class="col-md-12 chat_main"&gt;
                           &lt;div class="chat_body"&gt;
                                  &lt;!-- &lt;div class="chat_message float-right"&gt;Hello, &lt;/div&gt; --&gt;
                           &lt;/div&gt;
                          &lt;div class="row container" style="margin-left: 3px;"&gt;
                            &lt;div class="col-md-9 col-sm-9 less_padding"&gt;
                                &lt;textarea class="form-control" rows="1" id="Message"&gt;&lt;/textarea&gt;   
                            &lt;/div&gt;
                            &lt;div class="col-md-3 col-sm-3 less_padding"&gt;
                                  &lt;button type="submit" class="btn btn-primary" style=" position: absolute;" id="SendMessage"&gt;Send Message&lt;/button&gt;
                            &lt;/div&gt;
                          &lt;/div&gt;
                      &lt;/div&gt;
                   &lt;/div&gt;
               &lt;/div&gt;
            &lt;/div&gt;
            &lt;!-- Modal --&gt;
            &lt;div class="modal fade" id="CreateNewGroup" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true"&gt;
            &lt;div class="modal-dialog" role="document"&gt;
                &lt;div class="modal-content"&gt;
                 &lt;div class="modal-header"&gt;
                    &lt;h5 class="modal-title" id="exampleModalLongTitle"&gt;Add New Group&lt;/h5&gt;
                    &lt;button type="button" class="close" data-dismiss="modal" aria-label="Close"&gt;
                    &lt;span aria-hidden="true"&gt;&amp;times;&lt;/span&gt;
                    &lt;/button&gt;
                 &lt;/div&gt;
                &lt;div class="modal-body"&gt;
                    &lt;form id="CreateGroupForm"&gt;
                        &lt;div class="form-group"&gt;
                            &lt;label for="GroupName"&gt;Group Name&lt;/label&gt;
                            &lt;input type="text" class="form-control" name="GroupName" id="GroupName" aria-describedby="emailHelp" placeholder="Group Name"&gt;
                        &lt;/div&gt;
                        &lt;label for="User"&gt;Add Users &lt;br&gt;&lt;/label&gt; &lt;br&gt;
                        &lt;div class="row"&gt;
                             &lt;!-- List users here --&gt;
                        &lt;/div&gt;
                    &lt;/form&gt;
                &lt;/div&gt;
                &lt;div class="modal-footer"&gt;
                    &lt;button type="button" class="btn btn-secondary" data-dismiss="modal"&gt;Close&lt;/button&gt;
                    &lt;button type="button" class="btn btn-primary" id="CreateNewGroupButton"&gt;Create Group&lt;/button&gt;
                &lt;/div&gt;
              &lt;/div&gt;
            &lt;/div&gt;
          &lt;/div&gt;
        &lt;!-- Optional JavaScript --&gt;
        &lt;!-- jQuery first, then Popper.js, then Bootstrap JS --&gt;
        &lt;script src="https://code.jquery.com/jquery-3.2.1.min.js"&gt;&lt;/script&gt;
        &lt;script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"&gt;&lt;/script&gt;
        &lt;script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" integrity="sha384-a5N7Y/aK3qNeh15eJKGWxsqtnX/wWdSZSKp+81YjTmS15nvnvxKHuzaWwXHDli+4" crossorigin="anonymous"&gt;&lt;/script&gt;
        &lt;script src="https://js.pusher.com/4.1/pusher.min.js"&gt;&lt;/script&gt;
        &lt;script src="~/js/site.js" asp-append-version="true"&gt;&lt;/script&gt;
      &lt;/body&gt;
    &lt;/html&gt;
</code></pre>
<p>Notice this at the top of the file:</p>
<pre><code>    @{
        Layout = null;
    }

</code></pre>
<p>This is to tell the rendering engine not to include layouts partials(like header, footer) in this page. Also, we included the Pusher JavaScript library in this page. This will be discussed later.</p>
<p>You should now have a new route available -  <code>http://localhost:5000/chat</code>.  <code>/chat</code>  is the Controller’s name and since there is no other URL segment, this request will be mapped to the  <code>index</code>  method of the  <code>ChatController.cs</code>  method. Also in the index method, we have  <code>return View()</code>. This will render the view corresponding to the ChatController. It will look for the  <code>index.cshtml</code>  file in the  <code>/view/chat</code>  folder.</p>
<p>Heading to  <a href="http://locahost:5000/chat">http://locahost:5000/chat</a>  will redirect you to a login page. Register an account and log in then visit the page again. You should have an interface like below:</p>
<p><img src="https://images.contentful.com/1es3ne0caaid/4VvP2c76r6yUC4ggMiqEku/5ee8e586f9e01d9cf4551584a5af8fa5/group-chat-net-interface.png" alt=""></p>
<p>The left sidebar will be used to display all groups a user is subscribed to and the right side for all conversation messages in the groups. When a user clicks on a group, the corresponding message in that group will be displayed on the right. There is also a create group button. When a user clicks this button, a modal is displayed and the user can enter details of their new group. The modal will list all chat users. The group creator can select who they want to add to the group.</p>
<p>Now let’s get the group a user is subscribed to. After this, we’ll create a  <code>ViewModel</code>  to show the format of the output we want. Add the following code to the  <code>Index</code>  method in the  <code>ChatController.cs</code>  class:</p>
<pre><code>    [...]
    var groups =  _GroupContext.UserGroup
                        .Where( gp =&gt; gp.UserName == _userManager.GetUserName(User) )
                        .Join( _GroupContext.Groups, ug =&gt; ug.GroupId, g =&gt;g.ID, (ug,g) =&gt;
                                new UserGroupViewModel{
                                    UserName = ug.UserName, 
                                    GroupId = g.ID,
                                    GroupName = g.GroupName})
                        .ToList();

    ViewData["UserGroups"] = groups;

    // get all users      
    ViewData["Users"] = _userManager.Users;
    [...]
</code></pre>
<p>Here we made use of LINQ to make a query to get all groups in the UserGroup table that the current user is subscribed to. The raw SQL query is as follows:</p>
<pre><code>    SELECT "gp"."UserName", "g"."ID" AS "GroupId", "g"."GroupName"
                           FROM "UserGroup" AS "gp"
                           INNER JOIN "Groups" AS "g" ON "gp"."GroupId" = "g"."ID"
                           WHERE "gp"."UserName" = @__GetUserName_0
</code></pre>
<p>In the code above we used  <code>UserGroupViewModel</code>  to describe how the content of the query result should look, but we have not created the file. Create a new file -  <code>UserGroupViewModel.cs</code>  in the  <code>Models</code>  folder and add a view model:</p>
<pre><code>    using System;
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
</code></pre>
<blockquote>
<p>💡 A  <code>view model</code>  represents the data that you want to display on your view/page, or the input values you require for a request whether it be used for static text or for input values (like textboxes and dropdown lists) that can be added to the database. It is a model for the view.</p>
</blockquote>
<h3 id="display-data-to-the-chat-view">Display data to the chat view</h3>
<p>Now that we have the user’s groups and all the users, let’s display them on the view. Add this to the header of  <code>Views/chat/index.cshtml</code>:</p>
<pre><code>    @using Microsoft.AspNetCore.Identity
    @using GroupChat.Models

    @inject UserManager&lt;ApplicationUser&gt; UserManager
</code></pre>
<p>Update the html div that has an id=”groups” in  <code>Views/chat/index.cshtml</code>  as below:</p>
<pre><code>    [...]
    &lt;div clsss="row" style="height: 500px;overflow: scroll;" id="groups"&gt; 
        @foreach (var group in (dynamic)ViewData["UserGroups"]) {
            &lt;div class="group" data-group_id="@group.GroupId"&gt; @group.GroupName &lt;/div&gt; 
         }
    &lt;/div&gt;
    [...]
</code></pre>
<p>Notice that we are storing  <code>data-group_id</code>  for every group rendered. This is the Group ID of the  <code>Group</code>  table which is unique so we can keep track of all groups easily.</p>
<p>Let us also display the users to the modal form. Add the following code below this comment  <code>&lt;!--</code>  <code>List users here</code>  <code>--&gt;</code>  in  <code>Views/chat/index.cshtml</code>:</p>
<pre><code>    [...]
    &lt;!-- List users here --&gt;
    @foreach (var user in (dynamic)ViewData["Users"]) {
      &lt;div class="col-4"&gt; 
        &lt;div class="form-check"&gt;
           &lt;input type="checkbox" value="@user.UserName" name="UserName[]"&gt;
           &lt;label class="form-check-label" for="Users"&gt;@user.UserName&lt;/label&gt;
        &lt;/div&gt;
      &lt;/div&gt; 
    }
    [...]
</code></pre>
<h2 id="adding-groups">Adding groups</h2>
<p>Before a user can start chatting with their friends, they need to create a group and add users to it. Now, let us add a view model that will define the structure of our form input when creating a new group. Create a new file called  <code>NewGroupViewModel.cs</code>  in the  <code>Models</code>  folder then add the following code to it:</p>
<pre><code>    using System;
    using System.Collections.Generic;
    namespace GroupChat.Models
    {
        public class NewGroupViewModel
        {
            public string GroupName { get; set; }
            public List&lt;string&gt; UserNames { get; set; }
        }
    }
</code></pre>
<p>Next, create a new file called  <code>GroupController.cs</code>  in the Controllers folder. Then add the following code to  <code>GroupController.cs</code>:</p>
<pre><code>    using System;
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
            private readonly UserManager&lt;ApplicationUser&gt; _userManager;

            public GroupController(GroupChatContext context, UserManager&lt;ApplicationUser&gt; userManager)
            {
                _context = context;
                _userManager = userManager;
            }

            [HttpGet]
            public IEnumerable&lt;UserGroupViewModel&gt; GetAll()
            {

                var groups = _context.UserGroup
                              .Where(gp =&gt; gp.UserName == _userManager.GetUserName(User))
                              .Join(_context.Groups, ug =&gt; ug.GroupId, g =&gt;g.ID, (ug,g) =&gt;
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
                if( (_context.Groups.Any(gp =&gt; gp.GroupName == group.GroupName)) == true ){
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
</code></pre>
<p>In the preceding code:</p>
<ol>
<li>The constructor uses  <a href="https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection">Dependency Injection</a>  to inject the database context (<code>GroupChatContext</code>  and  <code>ApplicationUser</code>) into the controller. We have injected  <code>GroupChatContext</code>  and  <code>ApplicationUser</code>  context into the class so we can have access to the contexts.</li>
<li>The  <code>GetAll</code>  method is a Get method request that will be used to get all groups a particular user is subscribed to.</li>
<li>The  <code>Create</code>  method is a POST method request that will be used to create a new group.</li>
<li>Using  <code>_context.Groups.Add(newGroup);</code>  <code>_context.SaveChanges();</code>, we added a new group to the database.</li>
<li>Finally, with  <code>return</code>  <code>new</code>  <code>ObjectResult</code>(<code>new</code>  <code>{ status = "</code>success<code>", data = newGroup });</code>, we returned a JSON that indicates the request was successful.</li>
</ol>
<p>Create a group by making an AJAX request to /api/group using a POST method. Add the following JavaScript code to  <code>/wwwroot/js/site.js</code>:</p>
<pre><code>    $("#CreateNewGroupButton").click(function(){
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
            success: (data) =&gt; {
                $('#CreateNewGroup').modal('hide');
            },
            dataType: 'json',
            contentType:'application/json'
        });

    });
</code></pre>
<h2 id="displaying-messages-for-an-active-group">Displaying messages for an active group</h2>
<p>When a user clicks on a particular group, we’ll fetch all messages in that group and display them on the page. To achieve this we’ll make use of JQuery and Ajax to make a request to an endpoint which we’ll expose later, by passing the group_id along with the request and then display the resulting data on the page.</p>
<h3 id="create-an-endpoint-for-displaying-messages-for-a-particular-group">Create an endpoint for displaying messages for a particular group</h3>
<p>Create a new file in the Controllers folder called  <code>MessageController.cs</code>  Then add the following code to  <code>MessageController.cs</code>  file:</p>
<pre><code>    using System;
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
            private readonly UserManager&lt;ApplicationUser&gt; _userManager;
            public MessageController(GroupChatContext context, UserManager&lt;ApplicationUser&gt; userManager)
            {
                _context = context;
                _userManager = userManager;
            }

            [HttpGet("{group_id}")]
            public IEnumerable&lt;Message&gt; GetById(int group_id)
            {
                return _context.Message.Where(gb =&gt; gb.GroupId == group_id);
            }
        }
    }
</code></pre>
<p>In the code above,  <code>[Route("api/[controller]")]</code>  added at the top of the file will create a base route -  <code>/api</code>.</p>
<p>Also we added  <code>[HttpGet("{group_id}")]</code>  to  <code>GetById</code>  method so we have a route -  <code>/api/message/{group_id}</code>. The route -  <code>/api/message/{group_id}</code>  will return all messages for a particular group.</p>
<h3 id="adding-ajax-request-to-get-the-messages-and-display-it">Adding Ajax Request to Get the Messages and Display It</h3>
<p>When a user clicks on a group, we’ll make a request to get all messages in that group. Add the following code to  <code>wwwroot/js/site.js</code>:</p>
<pre><code>    // When a user clicks on a group, Load messages for that particular group.
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

            message += `&lt;div class="row chat_message` +position+ `"&gt;
                             &lt;b&gt;` +data.addedBy+ `: &lt;/b&gt;` +data.message+ 
                       `&lt;/div&gt;`;
        });

            $(".chat_body").html(message);
        });

    });
</code></pre>
<h3 id="adding-a-view-model">Adding a view model</h3>
<p>This view will help us define the nature of the form inputs we’ll use to make requests when we are adding a new message. Create a new file in the  <code>Models</code>  folder called  <code>MessageViewModel.cs</code>:</p>
<pre><code>    using System;

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
</code></pre>
<p>We’ll discuss what we’ll use the  <code>SocketId</code>  for later in the article.</p>
<h3 id="add-method-for-adding-message">Add method for adding message</h3>
<p>Here, we’ll add a new method for adding messages to the database. Update  <code>MessageController.cs</code>  with the following code:</p>
<pre><code>    [...]
    [HttpPost]
    public IActionResult Create([FromBody] MessageViewModel message)
    {
        Message new_message = new Message { AddedBy = _userManager.GetUserName(User), message = message.message, GroupId = message.GroupId };

        _context.Message.Add(new_message);
        _context.SaveChanges();

        return new ObjectResult(new { status = "success", data = new_message });
    }
    [...]
</code></pre>
<p>We can now send messages and store them in our database. However, other users do not get the messages in realtime. This is where Pusher comes in.</p>
<h3 id="add-new-message-via-ajax">Add new message via Ajax</h3>
<p>When a user clicks on the send message button, we’ll make an AJAX call to the method we added above with the message payload so it gets saved in the database.</p>
<p>Add the following code to  <code>wwwroot/js/site.js</code>:</p>
<pre><code>    $("#SendMessage").click(function() {
        $.ajax({
            type: "POST",
            url: "/api/message",
            data: JSON.stringify({
                AddedBy: $("#UserName").val(),
                GroupId: $("#currentGroup").val(),
                message: $("#Message").val(),
                socketId: pusher.connection.socket_id
            }),
            success: (data) =&gt; {
                $(".chat_body").append(`&lt;div class="row chat_message float-right"&gt;&lt;b&gt;` 
                        +data.data.addedBy+ `: &lt;/b&gt;` +$("#Message").val()+ `&lt;/div&gt;`
                );

                $("#Message").val('');
            },
            dataType: 'json',
            contentType: 'application/json'
        });
    });
</code></pre>
<h2 id="making-our-messaging-realtime">Making our messaging realtime</h2>
<p>Users can now send messages and create groups, and details are saved in the database. However, other users cannot see the messages or groups in realtime.</p>
<p>We will make use of  <a href="https://pusher.com/docs/client_api_guide/client_private_channels">Private channel</a>  in Pusher which will restrict unauthenticated users from subscribing to channels they don’t have access to.</p>
<p>Basically, we will subscribe to a channel -  <code>group_channel</code>  and trigger an event -  <code>new_group</code>  when a new group is created, so when an event -  <code>new_group</code>  is triggered, we update the group tab for all users (we can use  <a href="https://pusher.com/docs/client_api_guide/client_public_channels">Public channel</a>  for this).</p>
<p>We will also subscribe to other channels for messaging -  <code>private-1</code>,  <code>private-2</code>  etc but this will be a private channel because users who are not not subscribe to a particular group should not subscribe to it.</p>
<h3 id="add-pusher-.net-package">Add Pusher .NET package</h3>
<p>From your command line, make sure you are in the root folder of your project then type:</p>
<pre><code>    $ dotnet add package PusherServer

</code></pre>
<h3 id="adding-authentication-for-private-channel">Adding authentication for private channel</h3>
<p>When a user wants to subscribe to a private channel, Pusher will authenticate the user to make sure they have the right to subscribe to it by making a request to our authentication logic.</p>
<p>We will create a route -  <code>pusher/auth</code>  which Pusher will use for authentication.</p>
<p>Lets create an endpoint that Pusher will make a request to when it wants to authenticate a user. Create the route by adding the following code to  <code>Startup.cs</code>:</p>
<pre><code>    app.UseMvc(routes =&gt;
    {
       [...]
       routes.MapRoute(
            name: "pusher_auth",
            template: "pusher/auth",
            defaults: new { controller = "Auth", action = "ChannelAuth" });
      [...]
    });
</code></pre>
<p>Next, create a new file called  <code>AuthController.cs</code>  in the  <code>Controller</code>  folder and add the following code to it:</p>
<pre><code>    using System;
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
            private readonly UserManager&lt;ApplicationUser&gt; _userManager;

            public AuthController( GroupChatContext context, UserManager&lt;ApplicationUser&gt; userManager){
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
                                          .Where(gb =&gt; gb.GroupId == group_id 
                                                &amp;&amp; gb.UserName == _userManager.GetUserName(User))
                                          .Count();

                if( IsInChannel &gt; 0){
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
</code></pre>
<p>Pusher will send along the Channel name and Socket Id of the user it wants to authenticate, here we extracted the group Id from the channel name. Then we query our database to check if that user is in that group. To make a private channel in Pusher, you just need to add  <code>Private-</code>  to the channel name you intend to use. In our case, we are using  <code>private-1</code>,  <code>private-2</code>  etc as the channel name.</p>
<h3 id="triggering-an-event-when-a-group-is-created">Triggering an Event When a Group Is Created</h3>
<p>We’ll trigger an event to Pusher when a new group is created so others will see the newly created group.</p>
<p>Add the following code to the  <code>Create</code>  method in  <code>GroupController.cs</code>  before  <code>return new ObjectResult(new { status = success, data = newGroup });</code>  statement:</p>
<pre><code>    var options = new PusherOptions
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
</code></pre>
<p>Make sure you use your own Pusher app details above.</p>
<p>Also, add this to the top of the file:</p>
<pre><code>using PusherServer;

</code></pre>
<h3 id="triggering-an-event-when-a-new-message-is-received">Triggering an event when a new message is received</h3>
<p>To trigger an event when a new message is added, add the following code to  <code>MessageController.cs</code>:</p>
<pre><code>    var options = new PusherOptions
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
</code></pre>
<p>Make sure you use your own Pusher app details above.</p>
<p>We have added  <code>new TriggerOptions() { SocketId = message.SocketId }</code>, so as not to broadcast to the user that triggered the event.</p>
<p>Also, add this to the top of  <code>GroupController.cs</code>:</p>
<pre><code>    using PusherServer;

</code></pre>
<h3 id="display-the-new-group-when-a-user-creates-a-group">Display the new group when a user creates a group</h3>
<p>When a new group is created, we will reload the groups for every user. Add the following function to  <code>wwwroot/js/site.js</code>:</p>
<pre><code>    function reloadGroup(){
        $.get("/api/group", function( data ) {
            let groups = "";

           data.forEach(function(group){
               groups += `&lt;div class="group" data-group_id="` 
                               +group.groupId+ `"&gt;` +group.groupName+  
                          `&lt;/div&gt;`;
           });

           $("#groups").html(groups);
        });
    }
</code></pre>
<h3 id="listen-for-new-group">Listen for new group</h3>
<p>When a new group is created, we will call the  <code>reloadGroup()</code>  function. To listen for events, we need to initialize Pusher’s Javascript library. Add the following code to  <code>/wwwroot/js/site.js</code>:</p>
<pre><code>    let currentGroupId = null;

    var pusher = new Pusher('PUSHER_APP_KEY', {
                 cluster: 'PUSHER_APP_CLUSTER',
                 encrypted: true
    });

    var channel = pusher.subscribe('group_chat');
    channel.bind('new_group', function(data) {
       reloadGroup();
    });
</code></pre>
<p>Make sure to add this to the top part of the code because some other code in the file will be using it.</p>
<p>In the preceding code:</p>
<ol>
<li>We initiated the Pusher JavaScript library using our Pusher key.</li>
<li>Then we suscribed to a channel -  <code>group_chat</code>.</li>
<li>Then we bound that channel to an event -  <code>new_group</code>. So when a new group is created, we call the function  <code>reloadGroup()</code>.</li>
</ol>
<h3 id="listen-for-new-message">Listen for new message</h3>
<p>When a user sends a message, we need to show it to other users in the group. To do this, we will subscribe to a channel and bind that channel to an event. Add this to the  <code>$("#groups").on("click", ".group", function()…</code>  event in  <code>/wwwroot/js/site.js</code>:</p>
<pre><code>    if( !pusher.channel('private-'+group_id) ){ // check if the user have subscribed to the channel before.
        let group_channel = pusher.subscribe('private-'+group_id);

        group_channel.bind('new_message', function(data) { 

          if (currentGroupId == data.new_message.GroupId) {
              $(".chat_body").append(`&lt;div class="row chat_message"&gt;&lt;b&gt;` 
                  +data.new_message.AddedBy+ `: &lt;/b&gt;` +data.new_message.message+ ` &lt;/div&gt;`
              );
          ']}

        });  
    }           
</code></pre>
<p>So it should now look like this:</p>
<pre><code>    // When a user clicks on a group, Load messages for that particular group.
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
                    message += `&lt;div class="row chat_message` + position +`"&gt;&lt;b&gt;`+ data.addedBy +`: &lt;/b&gt;`+ data.message +` &lt;/div&gt;`;
            });

            $(".chat_body").html(message);
        });
        if( !pusher.channel('private-'+group_id) ){ // check the user have subscribed to the channel before.
            let group_channel = pusher.subscribe('private-'+group_id);

            group_channel.bind('new_message', function(data) { 
                 if( currentGroupId == data.new_message.GroupId){

                      $(".chat_body").append(`&lt;div class="row chat_message"&gt;&lt;b&gt;`+ data.new_message.AddedBy +`: &lt;/b&gt;`+ data.new_message.message +` &lt;/div&gt;`);
                 }
              });  
        }
    });
</code></pre>
<h2 id="conclusion">Conclusion</h2>
<p>So far, we have seen how to create a group chat application in <a href="http://ASP.NET">ASP.NET</a> Core MVC by leveraging Pusher as a technology for adding realtime functionality. You can find the complete code on  <a href="https://github.com/dongido001/Dotnet_GroupChat_Using_Pusher">Github</a>.</p>

