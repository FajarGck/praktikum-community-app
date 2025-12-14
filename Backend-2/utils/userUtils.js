const filterUsersResponse = (user) => ({
    user_id: user.user_id,
    username: user.username,
    email: user.email,
    role: user.role,
    foto_profil: user.foto_profil,
    created_at: user.created_at
})

module.exports = {
    filterUsersResponse
}