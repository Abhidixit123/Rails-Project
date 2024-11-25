document.addEventListener('DOMContentLoaded', () => {
    const signOutButtons = document.querySelectorAll('.sign-out-button');
    signOutButtons.forEach(button => {
      button.addEventListener('click', (event) => {
        if (!confirm('Are you sure to logout?')) {
          event.preventDefault(); // Cancel the action
        }
      });
    });
  });
